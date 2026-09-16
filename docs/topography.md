---
scope: root
updated: 2026-09-16
---

# Topography

## Layout

```text
lib/                  the whole site; compiles twice (server pre-render + client wasm)
lib/data/             repository, the two seams, and the wire DTO
lib/data/dto/         contact_draft_dto.dart — the shape functions/api/contact.ts reads
lib/data/repositories/ site_content_repository.dart — the SiteContent aggregate and its source
lib/data/services/    clipboard.dart, contact_dispatcher.dart — the two browser/network seams
lib/domain/           models and the failure family; no Jaspr components except AppIcon's use
lib/domain/models/    site_content.dart (every user-visible string), contact_draft.dart
lib/routing/          routes.dart — the ShellRoute + one Route('/')
lib/ui/core/          chrome, shared components, tokens, and the hand-rolled bloc binding
lib/ui/home/          the home page and its six section bands
lib/ui/contact/       the contact form island and its ViewModel
lib/ui/copy_email/    the copy-email button island and its ViewModel
lib/utils/            small pure helpers
lib/di/               get_it registrations
test/                 mirrors lib/ one-for-one, pure Dart (no browser)
tool/                 build-time Dart scripts run after jaspr build
functions/            Cloudflare Pages Functions (TypeScript) — sibling of build/, never inside
web/                  static assets copied verbatim: icons, images, manifest, _headers
docs/                 decisions.md, constraints.md, plans/, this map
.claude/skills/       Jaspr skill packs — read before applying other-framework habits
```

Each feature under `lib/ui/` is `view/` beside `view_model/`: the view renders, the ViewModel is a
`Cubit` holding the state that view needs. `lib/ui/core/` is the feature the chrome belongs to.

## Concerns

| Concern | Where | Naming | Example | Add new |
| --- | --- | --- | --- | --- |
| Route | `lib/routing/routes.dart` | one `List<RouteBase> get routes`, a `ShellRoute` over the page routes | `lib/routing/routes.dart` | an entry in that list, its page under `lib/ui/<feature>/view/` |
| Page | `lib/ui/<feature>/view/<name>_page.dart` | `class <Name>Page extends StatelessComponent`, composed of section children | `lib/ui/home/view/home_page.dart` | page file + its route entry + a ViewModel beside it |
| Page section | `lib/ui/home/view/sections/*.dart` | `class <Name> extends StatelessComponent`, opens its own `BlocBuilder<HomeViewModel, HomeState>` | `lib/ui/home/view/sections/hero.dart` | section file + its `<Name>Content` field in `lib/domain/models/site_content.dart` + a field on `HomeState` + the child list in `home_page.dart` |
| Chrome | `lib/ui/core/view/*.dart` | `AppShell` takes the routed `child`; `SiteHeader`, `SiteFooter` read `AppShellState`; `CosmosBackdrop` is the fixed decorative ground and reads nothing | `lib/ui/core/view/app_shell.dart` | rarely — the shell is what every route renders inside |
| Component | `lib/ui/core/components/*.dart` | `class <Name> extends StatelessComponent`, `@css static List<StyleRule> get styles`, data in through the constructor | `lib/ui/core/components/section_shell.dart` | component file + a case in `test/ui/core/components/layout_test.dart` |
| Island (browser code) | `lib/ui/<feature>/view/*.dart`, annotated `@client` | `@client` + **unnamed** constructor, resolves its ViewModel from `get_it` | `lib/ui/copy_email/view/copy_email_button.dart` | feature directory with `view/` + `view_model/` + a registration in `lib/di/injector.dart` |
| ViewModel | `lib/ui/<feature>/view_model/<name>_view_model.dart` | `<Name>ViewModel extends Cubit<<Name>State>`, takes `SiteContentRepository` | `lib/ui/contact/view_model/contact_view_model.dart` | ViewModel + `<name>_state.dart` + `lib/di/injector.dart` + `test/ui/<feature>/view_model/<name>_view_model_test.dart` |
| ViewModel state | `lib/ui/<feature>/view_model/<name>_state.dart` | `Equatable` class carrying exactly what its view renders, copy included | `lib/ui/copy_email/view_model/copy_state.dart` | alongside its ViewModel |
| Bloc binding | `lib/ui/core/binding/bloc_provider.dart`, `bloc_builder.dart` | hand-rolled, no `jaspr_bloc` | `lib/ui/core/binding/bloc_builder.dart` | rarely — `BlocBuilder` must pass `stream: kIsWeb ? bloc.stream : null` |
| Copy / strings | `lib/domain/models/site_content.dart` | `const` classes `<Section>Content`, one `SiteContent` root | `lib/domain/models/site_content.dart` | add field to the `*Content` class; never declare copy in a `build` |
| Design tokens & global CSS | `lib/ui/core/theme.dart` | `abstract final class App<Thing>` — `AppColors`, `AppType`, `AppSpacing`, `AppMotion`, `AppBorders`, `AppGrid`, `AppFocus` | `lib/ui/core/theme.dart` | token in `lib/ui/core/theme.dart`, mirrored from `DESIGN.md` frontmatter |
| DTO / wire type | `lib/data/dto/*_dto.dart` | `<Name>Dto`, `@JsonSerializable(createFactory: false)`, plus a `to<Name>Dto()` extension on the domain type | `lib/data/dto/contact_draft_dto.dart` | DTO file + `part '<name>_dto.g.dart'` + `test/data/dto/<name>_dto_test.dart`; run `just generate` |
| Repository | `lib/data/repositories/*.dart` | abstract `<Name>Repository` + a `Const`/`Http` prefixed impl | `lib/data/repositories/site_content_repository.dart` | repository file + a registration in `lib/di/injector.dart` + `test/data/repositories/<name>_test.dart` |
| Data seam | `lib/data/services/*.dart` | abstract `<Name>` + `Const`/`Browser`/`Http` prefixed impl | `lib/data/services/contact_dispatcher.dart` | service file + a registration in `lib/di/injector.dart` + `test/data/services/<name>_test.dart` |
| Domain model | `lib/domain/models/*.dart` | plain Dart; a builder beside the value where one is edited field by field | `lib/domain/models/contact_draft.dart` | model file + `test/domain/models/<name>_test.dart` |
| DI | `lib/di/injector.dart` | `configureDependencies()`, idempotent, one `getIt` cascade | `lib/di/injector.dart` | one line in the cascade |
| Pure helpers | `lib/utils/*.dart` | extensions or top-level fns | `lib/utils/markup.dart` | helper + `test/utils/<name>_test.dart` |
| Tests | `test/<mirror of lib>/<name>_test.dart` | `dart test`, VM only | `test/ui/contact/view_model/contact_view_model_test.dart` | mirror the `lib/` path |
| Render test helper | `test/ui/core/components/render.dart` | a `ServerTester` extension returning an `html` `Document`, plus `useAppOptions()` | `test/ui/core/components/render.dart` | reuse it, don't re-pump by hand; call `useAppOptions()` first in any file that renders a `@client` island |
| Contact endpoint | `functions/api/*.ts` | file path is the route — contact.ts serves /api/contact | `functions/api/contact.ts` | `.ts` file + `npm run types` + a `DispatchException` in `lib/domain/dispatch_outcome.dart` and its case in `HttpContactDispatcher._outcomeFor` |
| Static assets | `web/**` | copied verbatim to the site root | `web/images/portrait.jpg` | drop the file in `web/` |
| Build script | `tool/*.dart` | `dart run tool/<name>.dart`, runs after `jaspr build` | `tool/hash_assets.dart` | script + a line in the `build` recipe of `justfile` |
| CI / deploy | `.github/workflows/ci.yml` | single workflow; builds, gates, `wrangler pages deploy` from repo root | `.github/workflows/ci.yml` | edit the one workflow |
| Constraints | `docs/constraints.md` | prose, grouped by area | `docs/constraints.md` | add the rule and what breaks without it |
| Decisions | `docs/decisions.md` | prose ledes, plus the `D`/`A` identifiers minted earlier | `docs/decisions.md` | append an entry; never restate it in a doc comment |
| Plans | `docs/plans/*.md` | free-form, never under `lib/` | `docs/plans/mvvm-routing-plan.md` | new `.md` under `docs/plans/` |

## Entry points

- server pre-render: `lib/main.server.dart` (also owns the `<head>`)
- client hydration: `lib/main.client.dart`
- route table: `lib/routing/routes.dart` — what `main.server.dart` hands to `Router`
- root component: `lib/ui/core/view/app_shell.dart` — the `ShellRoute`'s builder, deliberately not `@client`
- DI root: `lib/di/injector.dart` — runs from **both** entrypoints
- tokens source of truth: `DESIGN.md` frontmatter → `lib/ui/core/theme.dart`
- function secrets: a gitignored .dev.vars locally, named in `.dev.vars.example`

## Commands

- list recipes: `just`
- dev server (site + the contact endpoint, :8788): `just dev`
- site only, watching (:8080, no API): `just serve`
- build: `just build` (`jaspr build --experimental-wasm --sitemap-domain …` + `dart run tool/hash_assets.dart`)
- test: `just test` (`dart test`)
- analyze / format / types: `just analyze`, `just format-check`, `just types`
- everything before a commit: `just check`
- deploy gate: `just markers`

## Not where you expect

- **The router never hydrates.** There is one route, `/`, and nothing above it is `@client`, so
  `Link` and `Router.push` are unavailable by construction — every link is an in-page anchor and a
  cross-page one would be a full page load. What the router buys is the shell/page seam, SSG route
  registration, and `build/jaspr/sitemap.xml`.
- `lib/main.client.options.dart`, `lib/main.server.options.dart` and `lib/data/dto/*_dto.g.dart` are build output — never edit. The `.options.dart` pair is committed; `*_dto.g.dart` is git-ignored and comes from `just generate`. `jaspr build` regenerates all of them into `lib/`.
- **Primary constructors do not build** — see `docs/constraints.md` §Builds. Private named parameters do.
- CSS lives in Dart, not `.css` files: component-scoped in each component's `@css styles` getter, global in `lib/ui/core/theme.dart`.
- **`lib/domain/models/site_content.dart` imports `lib/ui/core/components/icons.dart`** — the one place `domain/` reaches into `ui/`. `AppIcon` renders an `<svg>` and owns the global `.icon` rule, so it is a UI type that content names rather than a data enum.
- `functions/` is TypeScript and a **sibling** of `build/jaspr/`; moving it inside stops it being a function, and the deploy still succeeds with every submission 404ing.
- `jaspr serve` does not serve `functions/` — only `just dev` does.
- `web/` is the asset dir, not a source dir; nothing there is compiled.
- `test/` has no widget/golden tiers — one `dart test` suite, server-rendered HTML asserted via `test/ui/core/components/render.dart`.
- `.claude/skills/` holds project-local Jaspr packs; consult them before applying habits from other web frameworks.
