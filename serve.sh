#!/usr/bin/env bash
# Preview the blog locally, drafts included: http://localhost:4000
# See .claude/local-setup.md for why it is set up this way.
set -euo pipefail
cd "$(dirname "$0")"

# Pin Ruby 3.3 (what GitHub Pages builds with); macOS's 2.6 and Homebrew's 4.x both fail.
export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"

# Build native gems against Xcode's own SDK: the default (Command Line Tools) SDK can be
# newer than Xcode's linker understands ("tapi error: unknown architecture arm64e.x1").
XCODE_SDK=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
[[ -d "$XCODE_SDK" ]] && export SDKROOT="$XCODE_SDK"

bundle config set --local path vendor/bundle >/dev/null
bundle check >/dev/null 2>&1 || bundle install
exec bundle exec jekyll serve --drafts --livereload "$@"
