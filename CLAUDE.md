# CLAUDE.md

## What this is

A personal static portfolio site built with Jaspr (`mode: static` in `pubspec.yaml`). Pages are
pre-rendered to HTML during `jaspr build`; components annotated `@client` are compiled to JavaScript and
hydrated in the browser.

## Commands

```bash
jaspr serve     # dev server on http://localhost:8080, builder in watch mode
jaspr build     # static output in build/jaspr/
dart analyze
dart format .
```

The Jaspr CLI is a global activation (`dart pub global activate jaspr_cli`), not a dev dependency.

## Code runs in two environments

`lib/app.dart` and every file it imports are compiled **twice** — once for the server during
pre-rendering, once for the client. A `dart:io` or `dart:html` import anywhere in that graph breaks one of
the two builds. Branch with `kIsWeb` instead, as `AppState.initState` already does, or split the
environment-specific half behind a conditional import.

This is the constraint that breaks builds here most often.

## Generated files

`lib/main.client.options.dart` and `lib/main.server.options.dart` are written by `jaspr_builder`. Never
edit them; they regenerate on `jaspr serve` / `jaspr build`.

## Styling

CSS is written in Dart, not in stylesheets.

- Component-scoped rules go in a `@css static List<StyleRule> get styles` getter on the component itself
  (see `Counter` in `lib/components/counter.dart`).
- Global rules live in `lib/constants/theme.dart`.
- Use the type-safe `css(...)` bindings and the shorthand enum syntax (`display: .flex`) rather than raw
  CSS strings.

`jaspr_lints` enforces `prefer_html_components`, `sort_children_last` and `styles_ordering`. Satisfy those
diagnostics rather than suppressing them.

## Design system

`DESIGN.md` is the source of truth. Its YAML frontmatter carries the token values; the prose below
describes intent.

**Known conflict — read the frontmatter, not the prose.** The frontmatter sets `primary: '#9ecaff'`, the
prose section names `#0175C2` as primary, and `lib/constants/theme.dart` hardcodes `#01589B`. New work
takes token values from the frontmatter. `theme.dart` should eventually derive its colours from those
tokens instead of hardcoding them; until it does, expect the mismatch.

## Skills

`.claude/skills/` carries the Jaspr packs — `jaspr-fundamentals`, `jaspr-styling`, `jaspr-js-interop`,
`jaspr-pre-rendering-and-hydration`, `jaspr-convert-html`. Consult them before applying habits from other
web frameworks; Jaspr's component and styling APIs look familiar but differ in the details.
