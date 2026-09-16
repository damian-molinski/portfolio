build_dir := "build/jaspr"

# List available recipes
default:
    @just --list

# Install both toolchains' dependencies
[group('setup')]
deps:
    dart pub get
    npm install
    @just generate

# Run the builders — json_serializable's .g.dart parts are not committed
[group('setup')]
generate:
    dart run build_runner build
    @# source_gen emits at 80 columns and ignores the formatter's page_width.
    @find lib -name '*.g.dart' -exec dart format {} +

# Dev server on :8080 with the builder watching. Does not serve /api/contact.
[group('site')]
serve:
    jaspr serve --experimental-wasm

# Pre-render the site to build/jaspr/, then content-hash the client bundle
[group('site')]
build:
    @# `RouteSettings` on its own emits nothing — the sitemap needs the domain on the command line.
    jaspr build --experimental-wasm --sitemap-domain https://damian-molinski.dev
    dart run tool/hash_assets.dart

# Remove the build output
[group('site')]
clean:
    rm -rf {{ build_dir }}

# Build, then serve the site and the contact endpoint on :8788
[group('functions')]
dev: build
    npm run pages-dev

# Type-check functions/ without emitting
[group('functions')]
types:
    npm run types

# Static analysis
[group('quality')]
analyze:
    dart analyze

# Format every Dart file in place
[group('quality')]
format:
    dart format .

# Fail if anything is unformatted, without rewriting it
[group('quality')]
format-check:
    dart format --output=none --set-exit-if-changed .

# Apply the analyzer's automated fixes
[group('quality')]
fix:
    dart fix --apply

# Cubits, the repository and the draft — pure Dart, no browser
[group('quality')]
test:
    dart test

# Everything that must pass before a commit
[group('quality')]
check: analyze format-check test types

# The deploy gate — fails while any placeholder copy is left
[group('release')]
markers:
    @grep -rn '\[\[TODO:' lib/ --include='*.dart' || exit 0
    @! grep -rq '\[\[TODO:' lib/ --include='*.dart'
