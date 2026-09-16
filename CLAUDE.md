# CLAUDE.md

A personal static portfolio site — one page, no backend but a contact endpoint.

- **Dart / Jaspr in `mode: static`.** Pages pre-render to HTML during `jaspr build`; the two
  `@client` components compile to WebAssembly and hydrate in the browser.
- **TypeScript in `functions/`** — a Cloudflare Pages Function relaying the contact form
  through Resend. Deployed by direct upload from `.github/workflows/ci.yml`.

## Where to look

| For | Read |
| --- | --- |
| Where a concern lives, what it's named, what to touch when adding one | `docs/topography.md` |
| Rules that break the build or the site if ignored | `docs/constraints.md` |
| Why the code is the way it is (`D`/`A` identifiers) | `docs/decisions.md` |
| Design tokens — the YAML frontmatter is the source of truth | `DESIGN.md` |
| Jaspr itself, before applying habits from other web frameworks | `.claude/skills/` |
| Work in flight | `docs/plans/` |

## Commands

```bash
just              # list every recipe, grouped
just check        # dart analyze + format + test + tsc --noEmit
just dev          # jaspr build, then wrangler pages dev on :8788
just markers      # the deploy gate
```

`just` and the Jaspr CLI are global installs, not repo dependencies; each recipe is one line of the
`justfile`. `just dev` rebuilds first because `wrangler pages dev` serves the *built* output.
