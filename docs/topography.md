---
scope: root
updated: 2026-09-16
---

# Topography

## Layout

```text
lib/            the whole site; compiles twice (server pre-render + client wasm)
lib/sections/   one file per page band, composed by lib/app.dart
lib/components/ reusable presentational pieces, two of them @client islands
lib/constants/  theme.dart — every token and global style rule
lib/content/    site_content.dart — every user-visible string
lib/data/       repository + the two seams (clipboard, contact dispatcher)
lib/state/      cubits, their states, and the hand-rolled bloc binding
lib/utils/      small pure helpers
lib/di/         get_it registrations
test/           mirrors lib/ one-for-one, pure Dart (no browser)
tool/           build-time Dart scripts run after jaspr build
functions/      Cloudflare Pages Functions (TypeScript) — sibling of build/, never inside
web/            static assets copied verbatim: icons, images, manifest, _headers
docs/           decisions.md, plans/, this map
.claude/skills/ Jaspr skill packs — read before applying other-framework habits
```

## Concerns

| Concern | Where | Naming | Example | Add new |
| --- | --- | --- | --- | --- |
| Page section | `lib/sections/*.dart` | `class <Name> extends StatelessComponent`, file `snake_case` | `lib/sections/hero.dart` | section file + its `<Name>Content` field in `lib/content/site_content.dart` + child list in `lib/app.dart` |
| Component | `lib/components/*.dart` | `class <Name> extends StatelessComponent`, `@css static List<StyleRule> get styles` | `lib/components/section_shell.dart` | component file + `test/components/<name>_test.dart` |
| Island (browser code) | `lib/components/*.dart`, annotated `@client` | `@client` + **unnamed** constructor, resolves its cubit from `get_it` | `lib/components/copy_email_button.dart` | component + the annotation + cubit in `lib/state/` + registration in `lib/di/injector.dart` |
| Copy / strings | `lib/content/site_content.dart` | `const` classes `<Section>Content`, one `SiteContent` root | `lib/content/site_content.dart` | add field to the `*Content` class; never declare copy in a `build` |
| Design tokens & global CSS | `lib/constants/theme.dart` | `abstract final class App<Thing>` — `AppColors`, `AppType`, `AppSpacing`, `AppMotion`, `AppBorders`, `AppGrid`, `AppFocus` | `lib/constants/theme.dart` | token in `lib/constants/theme.dart`, mirrored from `DESIGN.md` frontmatter |
| Repository / data seam | `lib/data/*.dart` | abstract `<Name>` + `Const`/`Browser`/`Http` prefixed impl | `lib/data/contact_dispatcher.dart` | data file + a registration in `lib/di/injector.dart` + `test/data/<name>_test.dart` |
| Cubit | `lib/state/<name>_cubit.dart` | `<Name>Cubit extends Cubit<<Name>State>` | `lib/state/contact_cubit.dart` | cubit + `<name>_state.dart` + `lib/di/injector.dart` + `test/state/<name>_cubit_test.dart` |
| Cubit state | `lib/state/<name>_state.dart` | `Equatable` class or sealed family | `lib/state/copy_state.dart` | alongside its cubit |
| Bloc binding | `lib/state/bloc_provider.dart`, `lib/state/bloc_builder.dart`, `lib/state/site_content_builder.dart` | hand-rolled, no `jaspr_bloc` | `lib/state/bloc_builder.dart` | rarely — `BlocBuilder` must pass `stream: kIsWeb ? bloc.stream : null` |
| DI | `lib/di/injector.dart` | `configureDependencies()`, idempotent, one `getIt` cascade | `lib/di/injector.dart` | one line in the cascade |
| Pure helpers | `lib/utils/*.dart` | extensions or top-level fns | `lib/utils/markup.dart` | helper + `test/utils/<name>_test.dart` |
| Tests | `test/<mirror of lib>/<name>_test.dart` | `dart test`, VM only | `test/state/contact_cubit_test.dart` | mirror the `lib/` path |
| Render test helper | `test/components/render.dart` | a `ServerTester` extension returning an `html` `Document` | `test/components/render.dart` | reuse it, don't re-pump by hand |
| Contact endpoint | `functions/api/*.ts` | file path is the route — contact.ts serves /api/contact | `functions/api/contact.ts` | `.ts` file + `npm run types` + a `DispatchFailure` case in `lib/data/contact_dispatcher.dart` |
| Static assets | `web/**` | copied verbatim to the site root | `web/images/portrait.jpg` | drop the file in `web/` |
| Build script | `tool/*.dart` | `dart run tool/<name>.dart`, runs after `jaspr build` | `tool/hash_assets.dart` | script + a line in the `build` recipe of `justfile` |
| CI / deploy | `.github/workflows/ci.yml` | single workflow; builds, gates, `wrangler pages deploy` from repo root | `.github/workflows/ci.yml` | edit the one workflow |
| Constraints | `docs/constraints.md` | prose, grouped by area | `docs/constraints.md` | add the rule and what breaks without it |
| Decisions | `docs/decisions.md` | `D`/`A` identifiers | `docs/decisions.md` | append an entry; never restate it in a doc comment |
| Plans | `docs/plans/*.md` | free-form, never under `lib/` | `docs/plans/presence-plan.md` | new `.md` under `docs/plans/` |

## Entry points

- server pre-render: `lib/main.server.dart` (also owns the `<head>`)
- client hydration: `lib/main.client.dart`
- root component: `lib/app.dart` — deliberately not `@client`
- DI root: `lib/di/injector.dart` — runs from **both** entrypoints
- tokens source of truth: `DESIGN.md` frontmatter → `lib/constants/theme.dart`
- function secrets: a gitignored .dev.vars locally, named in `.dev.vars.example`

## Commands

- list recipes: `just`
- dev server (site + the contact endpoint, :8788): `just dev`
- site only, watching (:8080, no API): `just serve`
- build: `just build` (`jaspr build --experimental-wasm` + `dart run tool/hash_assets.dart`)
- test: `just test` (`dart test`)
- analyze / format / types: `just analyze`, `just format-check`, `just types`
- everything before a commit: `just check`
- deploy gate: `just markers`

## Not where you expect

- **No router.** Single page; `lib/app.dart` composes the sections in order and links are in-page anchors.
- `lib/main.client.options.dart` and `lib/main.server.options.dart` are `jaspr_builder` output — never edit.
- CSS lives in Dart, not `.css` files: component-scoped in each component's `@css styles` getter, global in `lib/constants/theme.dart`.
- `functions/` is TypeScript and a **sibling** of `build/jaspr/`; moving it inside stops it being a function, and the deploy still succeeds with every submission 404ing.
- `jaspr serve` does not serve `functions/` — only `just dev` does.
- `web/` is the asset dir, not a source dir; nothing there is compiled.
- `test/` has no widget/golden tiers — one `dart test` suite, server-rendered HTML asserted via `test/components/render.dart`.
- `.claude/skills/` holds project-local Jaspr packs; consult them before applying habits from other web frameworks.
