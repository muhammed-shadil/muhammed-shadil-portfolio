<#
.SYNOPSIS
    One command to update the live portfolio.

.DESCRIPTION
    Runs every quality gate locally, commits, pushes, then watches the GitHub
    Actions run until the new version is actually live.

    The build itself happens in CI, not here — that keeps the ~38 MB of build
    output out of git history and guarantees the deployed site was produced by
    a clean checkout rather than whatever happened to be in your build folder.

.EXAMPLE
    .\tool\deploy.ps1
    Commits any changes as "Update portfolio" and deploys.

.EXAMPLE
    .\tool\deploy.ps1 -Message "Add Kinetix case study"

.EXAMPLE
    .\tool\deploy.ps1 -Redeploy
    Nothing changed, but rebuild and republish the site anyway.

.EXAMPLE
    .\tool\deploy.ps1 -Check
    Run the quality gates only. Commits nothing, pushes nothing.
#>
[CmdletBinding()]
param(
    # Commit message for any pending changes.
    [string]$Message = "Update portfolio",

    # Skip `flutter test`. Use only when you know the tests are green.
    [switch]$SkipTests,

    # Push and exit without waiting for the deployment to finish.
    [switch]$NoWait,

    # Force a rebuild when there is nothing to commit (empty commit).
    [switch]$Redeploy,

    # Run the quality gates and stop. Nothing is committed or pushed.
    [switch]$Check
)

$ErrorActionPreference = 'Stop'

# Windows PowerShell 5.1 can still negotiate TLS 1.0 by default, which the
# GitHub API refuses. Without this the run-watcher fails with an unhelpful
# "underlying connection was closed".
try {
    [Net.ServicePointManager]::SecurityProtocol =
        [Net.SecurityProtocolType]::Tls12 -bor [Net.ServicePointManager]::SecurityProtocol
} catch {
    # PowerShell 7+ manages this itself; nothing to do.
}

# --------------------------------------------------------------------- output
function Write-Step  ($text) { Write-Host "`n=> $text" -ForegroundColor Cyan }
function Write-Ok    ($text) { Write-Host "   $text"   -ForegroundColor Green }
function Write-Warn  ($text) { Write-Host "   $text"   -ForegroundColor Yellow }
function Write-Fail  ($text) { Write-Host "`nX  $text"  -ForegroundColor Red }

function Stop-With ($text) {
    Write-Fail $text
    exit 1
}

# Runs a native command and stops the script if it returns non-zero.
# $LASTEXITCODE is the only reliable success signal for an external exe.
function Invoke-Native ($what, $exe, [string[]]$argv) {
    & $exe @argv
    if ($LASTEXITCODE -ne 0) {
        Stop-With "$what failed (exit code $LASTEXITCODE)."
    }
}

# ---------------------------------------------------------------- preflight
# Always operate on the repository root, not wherever the shell happens to be.
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

Write-Host ""
Write-Host "  Portfolio deploy" -ForegroundColor White
Write-Host "  $repoRoot" -ForegroundColor DarkGray

if (-not (Test-Path (Join-Path $repoRoot 'pubspec.yaml'))) {
    Stop-With "pubspec.yaml not found - this does not look like the Flutter project root."
}

Write-Step "Checking the repository"

git rev-parse --is-inside-work-tree | Out-Null
if ($LASTEXITCODE -ne 0) { Stop-With "Not a git repository." }

$remoteUrl = (git remote get-url origin)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($remoteUrl)) {
    Stop-With "No 'origin' remote. Add one with: git remote add origin <url>"
}

# Accept both https://github.com/owner/repo(.git) and git@github.com:owner/repo.git
$match = [regex]::Match($remoteUrl, 'github\.com[:/]([^/]+)/(.+?)(\.git)?$')
if (-not $match.Success) {
    Stop-With "Could not read owner/repo from origin: $remoteUrl"
}
$owner = $match.Groups[1].Value
$repo  = $match.Groups[2].Value

$branch = (git rev-parse --abbrev-ref HEAD)
$liveUrl    = "https://$owner.github.io/$repo/"
$actionsUrl = "https://github.com/$owner/$repo/actions"

Write-Ok "repo    $owner/$repo"
Write-Ok "branch  $branch"
Write-Ok "live    $liveUrl"

if ($branch -ne 'main') {
    Write-Warn "The deploy workflow only runs on 'main'. You are on '$branch'."
    $answer = Read-Host "   Continue anyway? (y/N)"
    if ($answer -ne 'y') { Stop-With "Cancelled." }
}

# ------------------------------------------------------------- quality gates
Write-Step "Installing dependencies"
Invoke-Native "flutter pub get" "flutter" @("pub", "get")
Write-Ok "dependencies resolved"

# Formatting is applied here rather than merely checked, so the CI formatting
# gate can never fail on work that was about to be pushed anyway.
Write-Step "Formatting"
Invoke-Native "dart format" "dart" @("format", ".")
Write-Ok "formatted"

Write-Step "Analyzing"
Invoke-Native "flutter analyze" "flutter" @("analyze", "--fatal-infos")
Write-Ok "no analyzer issues"

if ($SkipTests) {
    Write-Step "Tests"
    Write-Warn "skipped (-SkipTests)"
} else {
    Write-Step "Testing"
    Invoke-Native "flutter test" "flutter" @("test")
    Write-Ok "all tests passed"
}

if ($Check) {
    Write-Host ""
    Write-Host "  Checks passed. Nothing was committed or pushed (-Check)." -ForegroundColor Green
    Write-Host ""
    exit 0
}

# -------------------------------------------------------------------- commit
Write-Step "Committing"

$dirty = git status --porcelain
if ([string]::IsNullOrWhiteSpace($dirty)) {
    Write-Ok "working tree already clean"
} else {
    git add -A
    if ($LASTEXITCODE -ne 0) { Stop-With "git add failed." }

    git commit -m $Message
    if ($LASTEXITCODE -ne 0) { Stop-With "git commit failed." }

    Write-Ok "committed: $Message"
}

# Is there anything for the remote to build?
#
# The default is 1 ("there is something to push") on purpose. Only a positive,
# successful comparison against the remote is allowed to set it to 0. If the
# fetch or the count fails for any reason - offline, declined auth prompt, or
# `origin/$branch` simply not existing yet on a first push - the script must
# fall through to `git push` and let git report the real error, rather than
# claiming "nothing to deploy" and exiting 0 without ever pushing.
$ahead = 1

git fetch origin $branch --quiet
if ($LASTEXITCODE -eq 0) {
    $counts = (git rev-list --left-right --count "origin/$branch...HEAD")
    if ($LASTEXITCODE -eq 0 -and $counts) {
        # Output is "<behind>`t<ahead>" - the right-hand side is HEAD-only.
        $ahead = [int]($counts -split '\s+')[1]
    }
} else {
    Write-Warn "Could not fetch origin/$branch - continuing to push anyway."
}

if ($ahead -eq 0) {
    if ($Redeploy) {
        git commit --allow-empty -m "Redeploy portfolio"
        if ($LASTEXITCODE -ne 0) { Stop-With "Empty commit failed." }
        Write-Ok "empty commit created to trigger a rebuild"
    } else {
        Write-Host ""
        Write-Warn "Nothing new to deploy - the remote already has this commit."
        Write-Warn "Use -Redeploy to rebuild and republish the site anyway."
        Write-Host ""
        exit 0
    }
}

# ---------------------------------------------------------------------- push
Write-Step "Pushing to origin/$branch"

# Record what the newest run was BEFORE pushing, so the watcher can tell the
# run it triggered apart from the previous one.
$previousRunId = $null
try {
    $runs = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo/actions/runs?per_page=1" `
        -Headers @{ 'User-Agent' = 'portfolio-deploy' } -TimeoutSec 20
    if ($runs.workflow_runs.Count -gt 0) { $previousRunId = $runs.workflow_runs[0].id }
} catch {
    # Not fatal - it only means the watcher has no baseline to compare against.
}

Invoke-Native "git push" "git" @("push", "origin", $branch)
$sha = (git rev-parse --short HEAD)
Write-Ok "pushed $sha"

if ($NoWait) {
    Write-Host ""
    Write-Host "  Pushed. GitHub Actions is building." -ForegroundColor Green
    Write-Host "  Progress: $actionsUrl" -ForegroundColor DarkGray
    Write-Host "  Live:     $liveUrl" -ForegroundColor DarkGray
    Write-Host ""
    exit 0
}

# ------------------------------------------------------------------- monitor
Write-Step "Waiting for GitHub Actions"
Write-Host "   $actionsUrl" -ForegroundColor DarkGray

# Unauthenticated GitHub API calls are capped at 60 per hour per IP. A 10s
# poll over a 15 minute window would burn 90 of them and start returning 403
# mid-deploy, so the interval is 20s (36 calls worst case, ~12 in practice)
# and a rate-limit response stops the watch cleanly instead of looking like a
# failed deployment.
$pollSeconds = 20
$deadline = (Get-Date).AddMinutes(12)
$run = $null
$rateLimited = $false

while ((Get-Date) -lt $deadline) {
    Start-Sleep -Seconds $pollSeconds
    try {
        $runs = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo/actions/runs?per_page=5" `
            -Headers @{ 'User-Agent' = 'portfolio-deploy' } -TimeoutSec 20
    } catch {
        $status = $null
        if ($_.Exception.Response) { $status = [int]$_.Exception.Response.StatusCode }
        if ($status -eq 403 -or $status -eq 429) {
            $rateLimited = $true
            break
        }
        Write-Warn "GitHub API unreachable, retrying..."
        continue
    }

    if ($runs.workflow_runs.Count -eq 0) { continue }

    # Prefer the run for the exact commit just pushed. Falling back to "newest"
    # is only safe while it differs from the run that existed before the push.
    $candidate = $runs.workflow_runs | Where-Object { $_.head_sha -like "$sha*" } | Select-Object -First 1
    if (-not $candidate) {
        $newest = $runs.workflow_runs[0]
        if ($null -ne $previousRunId -and $newest.id -eq $previousRunId) {
            Write-Host "   queued..." -ForegroundColor DarkGray
            continue
        }
        $candidate = $newest
    }

    $run = $candidate
    if ($run.status -eq 'completed') { break }

    Write-Host ("   {0}..." -f $run.status) -ForegroundColor DarkGray
}

if ($rateLimited) {
    Write-Host ""
    Write-Warn "GitHub's unauthenticated API rate limit was reached, so the"
    Write-Warn "deployment can no longer be watched from here."
    Write-Warn "The build itself is unaffected - follow it at:"
    Write-Warn "  $actionsUrl"
    Write-Host ""
    exit 0
}

Write-Host ""

if ($null -eq $run) {
    Write-Warn "No workflow run appeared within the timeout."
    Write-Warn "Check $actionsUrl - the workflow may not be enabled for this repo."
    exit 1
}

if ($run.status -ne 'completed') {
    Write-Warn "Still running after 15 minutes. Follow it at:"
    Write-Warn "  $($run.html_url)"
    exit 1
}

if ($run.conclusion -eq 'success') {
    Write-Host "  Deployed." -ForegroundColor Green
    Write-Host "  $liveUrl" -ForegroundColor White
    Write-Host ""
    Write-Host "  A hard refresh (Ctrl+Shift+R) may be needed - the previous" -ForegroundColor DarkGray
    Write-Host "  version is cached by a service worker." -ForegroundColor DarkGray
    Write-Host ""
    exit 0
}

Write-Fail "Deployment failed: $($run.conclusion)"
Write-Host "  Logs: $($run.html_url)" -ForegroundColor DarkGray
Write-Host ""
exit 1
