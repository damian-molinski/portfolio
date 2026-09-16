# Portfolio

Personal static portfolio site — one page, built with [Jaspr](https://docs.jaspr.site) and deployed
to Cloudflare Pages at [damian-molinski.dev](https://damian-molinski.dev/).

## Stack

- **Dart** `^3.10.0`, **Jaspr** `0.23.4` in `static` mode — pages are pre-rendered to HTML at build
  time; the two components annotated `@client` compile to WebAssembly and hydrate in the browser.
- **TypeScript** in `functions/` — one Cloudflare Pages Function, `/api/contact`, relaying the
  contact form through [Resend](https://resend.com).
- **jaspr_lints** `^0.7.2`, loaded through the analyzer plugin system (`plugins:` in
  `analysis_options.yaml`), on top of `package:lints/recommended.yaml`.

## Prerequisites

`just` and the Jaspr CLI are global installs, not repo dependencies:

```bash
brew install just
dart pub global activate jaspr_cli 0.23.4
just deps                 # dart pub get + npm install
```

The contact endpoint needs `RESEND_API_KEY`, `CONTACT_TO` and `CONTACT_FROM`. Copy
`.dev.vars.example` to `.dev.vars` to run it locally; without them it answers `503` and the form
says so.

## Commands

| Command | What it does |
| --- | --- |
| `just` | List every recipe, grouped. |
| `just serve` | Dev server on `:8080` with the builder watching. Does **not** serve `/api/contact`. |
| `just dev` | Build, then serve the site *and* the endpoint on `:8788` via `wrangler pages dev`. |
| `just build` | Static build into `build/jaspr/`, then content-hash the client bundle. |
| `just check` | `dart analyze` + format check + `dart test` + `tsc --noEmit`. Run before a commit. |
| `just markers` | The deploy gate: fails while any `[[TODO:` placeholder is left in `lib/`. |

## Architecture

Everything interactive that can be CSS is CSS — the ambient glow, the entrance animations, every
hover and focus treatment. Only `CopyEmailButton` and `ContactForm` are `@client`; annotating
`app.dart` instead would compile and hydrate the whole page.

Copy is data: every user-visible string is a typed `const` field in `lib/content/site_content.dart`,
and no component declares its own. Styles are Dart too — component-scoped rules in a `@css` getter,
tokens and global rules in `lib/constants/theme.dart`.

State is `bloc` + `get_it` with a small hand-rolled binding in `lib/state/`.

## Documentation

| For | Read |
| --- | --- |
| Where each concern lives and what to touch when adding one | `docs/topography.md` |
| Rules that break the build or the site if ignored | `docs/constraints.md` |
| Why the code is the way it is | `docs/decisions.md` |
| Colour roles, type scale, spacing tokens, component specs | `DESIGN.md` |
| Work in flight | `docs/plans/` |

`DESIGN.md`'s YAML frontmatter holds the token values and is the source of truth; the prose beneath
describes the intent. `lib/constants/theme.dart` declares those tokens — `AppColors`, `AppType`,
`AppSpacing`, `AppRadius`, `AppBreakpoints` and the rest — so UI code never restates a hex value.

## Deployment

Every push to `main` runs `.github/workflows/ci.yml`: a `check` job runs `just markers`, `just check`
and `just build` and uploads the output, then a `deploy` job — which cannot run unless `check`
passed — sends the pre-rendered site and `functions/` to Cloudflare Pages by direct upload. Nothing
else triggers the workflow.
