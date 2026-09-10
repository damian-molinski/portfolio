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

`lib/constants/theme.dart` declares those tokens as Dart — `AppColors`, `AppType`, `AppSpacing`,
`AppRadius`, `AppBreakpoints`, `AppAccent` — taken verbatim from the frontmatter. Take colours, type
steps and spacing from there; do not restate a hex value in a component. Translucent variants come
from the `Color.alpha()` extension in the same file, so `AppColors.tertiary.alpha(0.4)` rather than a
second literal palette.

**Known conflict — read the frontmatter, not the prose.** The frontmatter sets `primary: '#9ecaff'`
while the prose section names `#0175C2` as primary. The frontmatter wins; both roles exist and the
design uses them correctly, `primary` for text accents and `primary-container` for button fills.

`docs/reference/landing-page.html` is the design as rendered, archived before `design/` was deleted.
Read it for layout, spacing and markup structure — never for colour. Its embedded Tailwind config
overrides the frontmatter with a darker surface ramp, which this site deliberately does not use.

## The site carries placeholder copy

Every user-visible string is a literal `[[TODO: …]]` marker living in `lib/content/site_content.dart`,
and no component declares copy of its own. This is deliberate: the design's wording asserts things
that were never verified, so it ships as markers that cannot be mistaken for finished text. Add a
string by adding a field there, not by writing it into a `build` method. **The site must not be
deployed while `grep -rn '\[\[TODO:' lib/` returns anything.**

## Two `@client` components, and one trap

`CopyEmailButton` and `ContactForm` are the only JavaScript on the page; everything else is CSS.
`app.dart` is deliberately not `@client` — annotating the root would compile every section to
JavaScript and hydrate the whole document.

**A `@client` component must have an unnamed constructor.** Jaspr's hydration codegen reconstructs it
by calling one, so named constructors compile, analyze clean, pre-render correctly, and then fail the
client build with `Couldn't find constructor`. Only `jaspr build` catches it, and only once the
component is mounted somewhere.

## Skills

`.claude/skills/` carries the Jaspr packs — `jaspr-fundamentals`, `jaspr-styling`, `jaspr-js-interop`,
`jaspr-pre-rendering-and-hydration`, `jaspr-convert-html`. Consult them before applying habits from other
web frameworks; Jaspr's component and styling APIs look familiar but differ in the details.
