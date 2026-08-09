# Muhammed Shadil — Portfolio

A Flutter Web portfolio for a Senior Flutter Developer. Dark, glass-and-glow
visual language, scroll-driven reveals, an interactive project showcase with
full case-study pages, and a custom cursor on desktop.

**Live:** https://muhammed-shadil.github.io/muhammed-shadil-portfolio/

---

## Quick start

```bash
flutter pub get
flutter run -d chrome
```

To publish your changes, one command does everything:

```powershell
.\tool\deploy.ps1 -Message "What changed"
```

See [Deployment](#deployment) for what that runs and the one-time setup.

Requires Flutter 3.41+ / Dart 3.11+.

---

## Updating the content

**Everything on the site lives in one file: [`lib/data/portfolio_data.dart`](lib/data/portfolio_data.dart).**
No name, URL, or sentence is hard-coded in a widget. Adding a project, changing
a job title, or swapping a link is an edit to that file only.

```dart
// Add a project — it appears in the grid and gets a case-study page for free.
Project(
  id: 'my-app',                       // must be unique; used as the hero tag
  name: 'My App',
  tagline: 'One line for the card.',
  summary: 'Two or three sentences.',
  accent: Color(0xFF7C5CFF),          // tints the card, halo and detail header
  category: 'Mobile app',
  status: ProjectStatus.live,
  featured: true,                     // featured cards span two grid columns
  iconUrl: 'https://play-lh.googleusercontent.com/…=s512',
  monogram: 'MA',                     // fallback if the icon fails to load
  tech: ['Flutter', 'GetX'],
  features: ['…'],
  links: [ProjectLink(kind: LinkKind.playStore, url: '…')],
  detailBlocks: [DetailBlock(title: 'The problem', body: '…')],
  architecture: ['…'],
  results: ['…'],
),
```

### Changing the accent colour

Edit two constants in [`lib/core/theme/app_colors.dart`](lib/core/theme/app_colors.dart):

```dart
static const Color accent    = Color(0xFF7C5CFF); // violet
static const Color accentAlt = Color(0xFF22D3EE); // cyan
```

Every gradient, glow, focus ring, hover state, button and progress bar derives
from those two values.

---

## Architecture

```
lib/
├── main.dart                  entry point
├── app.dart                   MaterialApp, theme, scroll behaviour, text scaling
├── home_page.dart             section composition + scroll wiring
├── core/
│   ├── theme/                 colours, type scale, ThemeData
│   ├── constants/             sizes, radii, durations, curves
│   ├── responsive/            breakpoints, context extensions, content column
│   └── utils/                 link launching, section controller, SVG path parser
├── models/                    Project, skills, experience, stats, repos
├── data/portfolio_data.dart   ← ALL CONTENT
├── animations/                reveal, scroll visibility, counters, hover, typing
├── widgets/                   glass card, buttons, chips, grid, cursor, backdrop
└── sections/
    ├── navbar/  hero/  about/  skills/  projects/
    ├── experience/  process/  github/  resume/  contact/  footer/
```

### Notable decisions

**One runtime dependency.** Only `url_launcher`. Scroll reveals, counters,
hover states, the custom cursor, the particle backdrop, the typing effect and
the brand logos are all hand-written — which keeps the bundle small and means
nothing here breaks on someone else's release schedule.

**Fonts are bundled, not fetched.** Flutter Web with CanvasKit cannot use
fonts loaded via CSS `@font-face`, so `google_fonts`-style runtime downloads
would mean a visible fallback flash on every cold load. Space Grotesk, Inter
and JetBrains Mono ship in `assets/fonts`, trimmed to only the weights the type
scale requests.

**Brand logos are parsed SVG paths.** `lib/core/utils/svg_path.dart` is a small
path-data parser (M/L/H/V/C/S/Q/T/A/Z, absolute and relative, implicit repeats,
arc endpoint→centre conversion). Adding a logo is pasting its 24×24 path string
into `BrandPaths` — no `flutter_svg` dependency for eight glyphs.

**Scroll reveals share one listener.** A single `NotificationListener` feeds one
`ValueNotifier`; each `Reveal` subscribes, and unsubscribes the moment it has
fired. Work stays proportional to the number of *unrevealed* widgets, not to
every animated widget on the page.

**`ResponsiveGrid` instead of `Wrap` for cards.** `Wrap` sizes each child to its
own content, so card rows come out ragged, and a child inside one has unbounded
height. The grid packs children into explicit rows with `IntrinsicHeight`, so
every card in a row matches the tallest — and multi-column spans (featured
projects) work.

**The backdrop is one painter on one ticker.** Grid, glow fields, particles and
vignette are drawn in a single `CustomPainter` inside a `RepaintBoundary`, so
the whole atmosphere costs one repaint per frame and never invalidates the
content above it.

---

## Responsive behaviour

Verified at 320 / 375 / 414 / 768 / 1024 / 1440 / 1920.

| Breakpoint | Behaviour |
|---|---|
| `< 400` | single column, compact type, drawer nav |
| `400–699` | single column, larger type |
| `700–1023` | two-column grids, reduced spacing |
| `1024–1439` | full nav, two-column hero, hover + custom cursor enabled |
| `≥ 1440` | three-column project grid with two-column featured cards |

Hover-only affordances are gated on **both** width and a real hovering pointer
(`defaultTargetPlatform`), so mobile browsers on large screens behave correctly.

---

## Accessibility

- Every interactive element is focusable and activates on Enter/Space.
- `Escape` closes the mobile menu and the project detail page.
- Semantic labels on cards, icon buttons, nav links and social links.
- The OS **reduce motion** setting is honoured throughout: reveals resolve
  instantly, counters render their final value, the backdrop stops animating,
  the custom cursor is disabled, and the loading bar stops sliding.
- Text scaling is respected within a clamped 0.85×–1.35× range.
- Colour is never the only signal — the active nav item also carries a rule,
  and status badges pair colour with a label.

---

## Testing

```bash
flutter analyze
flutter test
```

The widget tests render the whole site at 1440px and at 320px and assert that
no exception is raised — which catches overflows, unbounded-constraint errors
and disposal bugs. Note that `flutter test` substitutes a fixed-width test font
that renders text considerably wider than the real fonts, so passing at 320px
is a stricter bar than the real layout has to clear.

---

## Deployment

The site is hosted from this repository on GitHub Pages at
**https://muhammed-shadil.github.io/muhammed-shadil-portfolio/**

### One-time setup — required once, takes five seconds

On github.com, in this repository:

**Settings → Pages → Build and deployment → Source: `GitHub Actions`**

This cannot be automated from here. The workflow does try
(`configure-pages` runs with `enablement: true`), but GitHub refuses that API
call on many accounts — it was refused on the first run of this repo, which is
why the step is marked `continue-on-error` and the switch has to be flipped by
hand once.

After that one click, every deploy is fully automatic. There is no `gh-pages`
branch to create and nothing to select afterwards.

### Updating the live site

```powershell
.\tool\deploy.ps1                              # commit as "Update portfolio", deploy
.\tool\deploy.ps1 -Message "Add case study"    # with a commit message
.\tool\deploy.ps1 -Check                       # run the gates only, change nothing
.\tool\deploy.ps1 -Redeploy                    # rebuild even with nothing to commit
.\tool\deploy.ps1 -NoWait                      # push and exit, don't watch the run
.\tool\deploy.ps1 -SkipTests                   # skip flutter test
```

Bash equivalent, same behaviour:

```bash
./tool/deploy.sh -m "Add case study"
./tool/deploy.sh --check --redeploy --no-wait --skip-tests
```

The script:

1. resolves the repo root, owner and repo name from `origin` — nothing is hard-coded
2. warns if you are not on `main` (the workflow only builds `main`)
3. `flutter pub get`
4. `dart format .` — applied, not just checked, so the CI format gate cannot
   fail on work you were about to push anyway
5. `flutter analyze --fatal-infos`
6. `flutter test`
7. commits everything and pushes
8. polls the GitHub API until the Actions run finishes, then prints the live URL
   or the failing run's log link

If there is nothing new to push it stops and tells you, rather than pretending
to deploy. `-Redeploy` makes an empty commit when you want a rebuild anyway.

### What runs in CI

[`.github/workflows/deploy.yml`](.github/workflows/deploy.yml) repeats the same
gates on a clean checkout, builds, and uploads the result as a Pages artifact.
The build output never enters git history — that matters here because
`build/web` is ~38 MB, most of it CanvasKit.

**The Flutter SDK is pinned** (`flutter-version: '3.41.6'`), not tracked to
`channel: stable`. Newer SDKs ship new analyzer lints, and with
`--fatal-infos` those turn an untouched repository red weeks after the last
commit — which is exactly how the first run of this workflow failed. Pinned SDK
plus the committed `pubspec.lock` means CI runs the same toolchain and the same
lint set as your machine.

To move to a newer Flutter, verify locally first, then bump the pin:

```bash
flutter upgrade
flutter analyze --fatal-infos && flutter test   # fix anything new
# then edit flutter-version in .github/workflows/deploy.yml to match
flutter --version
```

### Base href — the thing that breaks GitHub Pages deployments

Pages serves a project site from `/<repo-name>/`. If `--base-href` does not
match, every asset resolves against the domain root and **the page loads blank
with no error and nothing in the console to explain it**.

The workflow derives it from the repository name:

```yaml
flutter build web --release --base-href "/${{ github.event.repository.name }}/"
```

so renaming the repository cannot break the site, and a following step greps
`build/web/index.html` to prove the value landed before anything is published.

Building by hand instead? Then it must match:

- project site (`user.github.io/<repo>/`) → `--base-href "/<repo>/"`
- user site (`user.github.io`) or a custom domain at the root → `--base-href "/"`

> **Windows note:** a manual build must be run from PowerShell, not Git Bash.
> Git Bash rewrites the leading `/` into a Windows path and the build fails with
> `--base-href should start and end with /`. `tool/deploy.ps1` avoids this
> entirely by building in CI.

`web/404.html` derives the site root from the URL at runtime, so unknown paths
redirect correctly even if the repository is renamed.

### The old URL

The previous site at `muhammed-shadil.github.io/Shadil-Portfolio/` is a
separate repository and keeps serving its old build until you change it. If
anything already links there — a resume, LinkedIn, a job application — replace
that repo's `index.html` with
[`tool/old-site-redirect.html`](tool/old-site-redirect.html) so the old address
forwards here instead of showing a stale portfolio.

---

## SEO

Flutter Web paints to a canvas, so crawlers cannot read the rendered text. The
indexable content lives in `web/index.html`:

- `<title>`, description, canonical URL, keywords
- Open Graph and Twitter card metadata
- JSON-LD `Person` structured data (job title, location, skills, profiles)
- A `<noscript>` block with the real summary and contact links
- `robots.txt` and `sitemap.xml`

Update the URLs in those files if the site moves to a custom domain.

---

## Things worth knowing before you edit

**Material 3 dark themes.** Build the scheme with brightness passed *into* the
factory:

```dart
ColorScheme.fromSwatch(primarySwatch: …, brightness: Brightness.dark)  // correct
ColorScheme.fromSwatch(…).copyWith(brightness: Brightness.dark)        // black-on-black
```

`copyWith` flips only the flag and leaves `onSurface` black, so every default
Material text renders black on a black background.

**`late final` tickers.** A lazily-initialised `late final Ticker` that is only
touched in `build` will be *constructed inside `dispose()`* if the widget never
built that branch — and looking up the `TickerMode` ancestor there throws.
Create tickers in `initState`.

**The GitHub activity graph is illustrative,** and labelled as such in the UI.
To wire up real data, replace `ContributionData.sample` in
`lib/sections/github/contribution_grid.dart` with a `List<List<int>>` of 0–4
levels from the GitHub GraphQL `contributionsCollection` API. Nothing else
changes.
