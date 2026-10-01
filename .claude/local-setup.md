# Local preview setup (2026-10-01)

## Why

The blog is a Jekyll site (theme `minima`, dark skin) that GitHub Pages builds on push to
`main`. There was no way to preview it locally, so drafts could only be checked by publishing.
This setup lets you see posts **and drafts** rendered exactly as GitHub will render them,
with live reload while writing.

## How to use

```bash
./serve.sh            # http://localhost:4000, drafts included, live reload
./serve.sh --port 4001
```

First run installs gems into `vendor/bundle` (gitignored); later runs start straight away.

## How the blog works (reminder)

| What | Where | Notes |
| --- | --- | --- |
| Work in progress | `_drafts/<slug>.md` | No date in the filename. Only rendered with `--drafts` (what `serve.sh` does); dated by file mtime in the preview. Never published. |
| Published posts | `_posts/YYYY-MM-DD-<slug>.md` | Front matter `title:` + `date:`. The front-matter date wins over the filename. |
| Post images | `docs/assets/img/<post-slug>/` | Referenced absolute: `![alt](/docs/assets/img/<post-slug>/x.png)` |
| Publish | move draft → `_posts/` with a date, move its images → `docs/assets/img/`, commit, push `main` | GitHub Pages rebuilds in ~1 min. |

Images sitting loose in `_drafts/` won't show in the preview (Jekyll tries to read them as
posts and logs a red "invalid byte sequence in UTF-8" — harmless). Put a draft's images in
`docs/assets/img/<slug>/` from the start and they work both locally and once published.

## What we did

1. **`Gemfile`** — the `github-pages` gem (pins the same Jekyll 3.10 + plugins GitHub uses,
   so local == live), plus `webrick` and a few other gems newer Rubies no longer bundle.
2. **Ruby 3.3 via Homebrew** (`brew install ruby@3.3`, keg-only, not on PATH; `serve.sh`
   prepends it). GitHub Pages builds with 3.3. Rejected alternatives:
   - macOS system Ruby 2.6 — too old, and installs need sudo.
   - Homebrew `ruby` 4.0 — `github-pages` resolves to an ancient version (223) and
     `eventmachine` fails to compile.
3. **`SDKROOT` → Xcode's SDK** (in `serve.sh`). With Xcode 26.3 + Command Line Tools for
   macOS 27, the compiler defaulted to the CLT's MacOSX27 SDK, which Xcode's linker can't
   parse (`tapi error: ... unknown architecture arm64e.x1`), so *every* native gem
   (json, bigdecimal, http_parser.rb, …) failed with "compiler failed to generate an
   executable file". Pointing `SDKROOT` at
   `/Applications/Xcode.app/.../MacOSX.sdk` fixes it. If Xcode is later updated to match the
   OS, this line becomes unnecessary but stays harmless.
4. **`serve.sh`** — sets Ruby + SDK, installs gems if needed, runs
   `jekyll serve --drafts --livereload`.
5. **`.gitignore`** — `_site/`, `.jekyll-cache/`, `.sass-cache/`, `vendor/`, `.bundle/`.
6. **`_config.yml` `exclude:`** — keeps `Gemfile*`, `vendor`, `serve.sh` out of the site.
   In Jekyll 3, setting `exclude` replaces the defaults, so the defaults are listed too.
   (`.claude/` is a dotfolder, so Jekyll skips it automatically.)

`Gemfile.lock` is deliberately **not** committed: it is machine-specific, and GitHub Pages
ignores it anyway (it builds with its own pinned `github-pages` version).

## Harmless warnings you'll see

- `GitHub Metadata: No GitHub API authentication could be found` — only affects
  `site.github.*` fields, which this theme doesn't need locally.
- `To use retry middleware with Faraday v2.0+, install faraday-retry` — ignore.
