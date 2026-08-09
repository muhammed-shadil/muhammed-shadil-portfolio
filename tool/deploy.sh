#!/usr/bin/env bash
#
# One command to update the live portfolio (bash equivalent of deploy.ps1).
#
# Runs every quality gate locally, commits, pushes, then watches the GitHub
# Actions run until the new version is live. The build itself happens in CI,
# which keeps ~38 MB of build output out of git history.
#
# Usage:
#   ./tool/deploy.sh                      commit as "Update portfolio" and deploy
#   ./tool/deploy.sh -m "Add case study"  commit with a message
#   ./tool/deploy.sh --redeploy           rebuild even with nothing to commit
#   ./tool/deploy.sh --check              run the gates only, change nothing
#   ./tool/deploy.sh --no-wait            push and exit immediately
#   ./tool/deploy.sh --skip-tests         skip flutter test

set -euo pipefail

MESSAGE="Update portfolio"
SKIP_TESTS=0
NO_WAIT=0
REDEPLOY=0
CHECK_ONLY=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--message)  MESSAGE="$2"; shift 2 ;;
    --skip-tests)  SKIP_TESTS=1; shift ;;
    --no-wait)     NO_WAIT=1; shift ;;
    --redeploy)    REDEPLOY=1; shift ;;
    --check)       CHECK_ONLY=1; shift ;;
    # Prints the header comment only (lines 2-15). Widening this range spills
    # the shebang and the first lines of code into the help text.
    -h|--help)     sed -n '2,15p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; DIM='\033[2m'; OFF='\033[0m'
step() { printf "\n${CYAN}=> %s${OFF}\n" "$1"; }
ok()   { printf "   ${GREEN}%s${OFF}\n" "$1"; }
warn() { printf "   ${YELLOW}%s${OFF}\n" "$1"; }
die()  { printf "\n${RED}X  %s${OFF}\n" "$1"; exit 1; }

# Always operate on the repository root.
cd "$(dirname "$0")/.."
REPO_ROOT="$(pwd)"

printf "\n  Portfolio deploy\n"
printf "  ${DIM}%s${OFF}\n" "$REPO_ROOT"

[[ -f pubspec.yaml ]] || die "pubspec.yaml not found - not the Flutter project root."

step "Checking the repository"
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "Not a git repository."

REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"
[[ -n "$REMOTE_URL" ]] || die "No 'origin' remote. Add one with: git remote add origin <url>"

# Accepts https://github.com/owner/repo(.git), git@github.com:owner/repo.git and
# ssh://git@github.com/owner/repo.git.
#
# Note: bash uses POSIX ERE, which has no lazy quantifiers — a `(.+?)` here
# fails to compile and the match silently returns false for every URL. The
# capture is greedy and the trailing ".git" is stripped afterwards instead.
if [[ "$REMOTE_URL" =~ github\.com[:/]([^/]+)/([^/]+)$ ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]%.git}"
else
  die "Could not read owner/repo from origin: $REMOTE_URL"
fi

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
LIVE_URL="https://${OWNER}.github.io/${REPO}/"
ACTIONS_URL="https://github.com/${OWNER}/${REPO}/actions"

ok "repo    ${OWNER}/${REPO}"
ok "branch  ${BRANCH}"
ok "live    ${LIVE_URL}"

if [[ "$BRANCH" != "main" ]]; then
  warn "The deploy workflow only runs on 'main'. You are on '${BRANCH}'."
  read -r -p "   Continue anyway? (y/N) " answer
  [[ "$answer" == "y" ]] || die "Cancelled."
fi

step "Installing dependencies"
flutter pub get
ok "dependencies resolved"

# Applied, not just checked, so the CI formatting gate cannot fail on work
# that was about to be pushed anyway.
step "Formatting"
dart format .
ok "formatted"

step "Analyzing"
flutter analyze --fatal-infos
ok "no analyzer issues"

if [[ $SKIP_TESTS -eq 1 ]]; then
  step "Tests"
  warn "skipped (--skip-tests)"
else
  step "Testing"
  flutter test
  ok "all tests passed"
fi

if [[ $CHECK_ONLY -eq 1 ]]; then
  printf "\n  ${GREEN}Checks passed. Nothing committed or pushed (--check).${OFF}\n\n"
  exit 0
fi

step "Committing"
if [[ -z "$(git status --porcelain)" ]]; then
  ok "working tree already clean"
else
  git add -A
  git commit -m "$MESSAGE"
  ok "committed: ${MESSAGE}"
fi

# Defaults to 1 ("there is something to push") on purpose: only a successful
# comparison against the remote may set it to 0. If the fetch or the count
# fails - offline, or `origin/$BRANCH` not existing yet on a first push - fall
# through to `git push` and let git report the real error, rather than claiming
# "nothing to deploy" and exiting 0 without ever pushing.
AHEAD=1
if git fetch origin "$BRANCH" --quiet 2>/dev/null; then
  AHEAD="$(git rev-list --count "origin/${BRANCH}..HEAD" 2>/dev/null || echo 1)"
else
  warn "Could not fetch origin/${BRANCH} - continuing to push anyway."
fi

if [[ "$AHEAD" -eq 0 ]]; then
  if [[ $REDEPLOY -eq 1 ]]; then
    git commit --allow-empty -m "Redeploy portfolio"
    ok "empty commit created to trigger a rebuild"
  else
    printf "\n"
    warn "Nothing new to deploy - the remote already has this commit."
    warn "Use --redeploy to rebuild and republish the site anyway."
    printf "\n"
    exit 0
  fi
fi

step "Pushing to origin/${BRANCH}"

# Writes the HTTP status to stdout on the last line so callers can detect the
# 403 that GitHub returns once the unauthenticated rate limit is exhausted.
api() {
  curl -sS --max-time 20 -w '\n%{http_code}' -H 'User-Agent: portfolio-deploy' "$1" 2>/dev/null || true
}

# Baseline: the newest run before the push, so the watcher can tell the run it
# triggered apart from the previous one. `"id"` also appears on nested objects
# (actor, repository, head_commit), but the run's own id is the first field of
# the first array element, so head -1 is the right one.
PREVIOUS_RUN_ID="$(api "https://api.github.com/repos/${OWNER}/${REPO}/actions/runs?per_page=1" \
  | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*' || true)"

git push origin "$BRANCH"
SHA="$(git rev-parse --short HEAD)"
ok "pushed ${SHA}"

if [[ $NO_WAIT -eq 1 ]]; then
  printf "\n  ${GREEN}Pushed. GitHub Actions is building.${OFF}\n"
  printf "  ${DIM}Progress: %s${OFF}\n" "$ACTIONS_URL"
  printf "  ${DIM}Live:     %s${OFF}\n\n" "$LIVE_URL"
  exit 0
fi

step "Waiting for GitHub Actions"
printf "   ${DIM}%s${OFF}\n" "$ACTIONS_URL"

# Unauthenticated GitHub API calls are capped at 60/hour per IP. Polling every
# 10s for 15 minutes would burn 90 and start 403-ing mid-deploy, so the
# interval is 20s (36 worst case, ~12 in practice).
DEADLINE=$(( SECONDS + 720 ))
STATUS=""
CONCLUSION=""
RUN_URL="$ACTIONS_URL"
RATE_LIMITED=0

while [[ $SECONDS -lt $DEADLINE ]]; do
  sleep 20
  RESPONSE="$(api "https://api.github.com/repos/${OWNER}/${REPO}/actions/runs?per_page=5")"
  HTTP_CODE="$(printf '%s' "$RESPONSE" | tail -n1)"
  BODY="$(printf '%s' "$RESPONSE" | sed '$d')"

  if [[ "$HTTP_CODE" == "403" || "$HTTP_CODE" == "429" ]]; then
    RATE_LIMITED=1
    break
  fi

  [[ -n "$BODY" ]] || { warn "GitHub API unreachable, retrying..."; continue; }

  RUN_ID="$(printf '%s' "$BODY" | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*' || true)"
  [[ -n "$RUN_ID" ]] || continue

  if [[ -n "$PREVIOUS_RUN_ID" && "$RUN_ID" == "$PREVIOUS_RUN_ID" ]]; then
    printf "   ${DIM}queued...${OFF}\n"
    continue
  fi

  STATUS="$(printf '%s' "$BODY" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4 || true)"
  CONCLUSION="$(printf '%s' "$BODY" | grep -o '"conclusion":[^,]*' | head -1 | cut -d':' -f2 | tr -d ' "' || true)"
  RUN_URL="$(printf '%s' "$BODY" | grep -o '"html_url":"[^"]*actions/runs/[0-9]*"' | head -1 | cut -d'"' -f4 || true)"
  [[ -n "$RUN_URL" ]] || RUN_URL="$ACTIONS_URL"

  [[ "$STATUS" == "completed" ]] && break
  printf "   ${DIM}%s...${OFF}\n" "$STATUS"
done

printf "\n"

if [[ $RATE_LIMITED -eq 1 ]]; then
  warn "GitHub's unauthenticated API rate limit was reached, so the"
  warn "deployment can no longer be watched from here."
  warn "The build itself is unaffected - follow it at:"
  warn "  ${ACTIONS_URL}"
  printf "\n"
  exit 0
fi

if [[ "$STATUS" != "completed" ]]; then
  warn "Still running after 12 minutes. Follow it at:"
  warn "  ${RUN_URL}"
  exit 1
fi

if [[ "$CONCLUSION" == "success" ]]; then
  printf "  ${GREEN}Deployed.${OFF}\n"
  printf "  %s\n\n" "$LIVE_URL"
  printf "  ${DIM}A hard refresh (Ctrl+Shift+R) may be needed - the previous${OFF}\n"
  printf "  ${DIM}version is cached by a service worker.${OFF}\n\n"
  exit 0
fi

printf "${RED}X  Deployment failed: %s${OFF}\n" "$CONCLUSION"
printf "  ${DIM}Logs: %s${OFF}\n\n" "$RUN_URL"
exit 1
