build_dir := "build/jaspr"

# List available recipes
default:
    @just --list

# Install both toolchains' dependencies
[group('setup')]
deps:
    dart pub get
    npm install

# Dev server on :8080 with the builder watching. Does not serve /api/contact.
[group('site')]
serve:
    jaspr serve

# Pre-render the site to build/jaspr/, then content-hash the client bundle
[group('site')]
build:
    jaspr build
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
