# CLAUDE.md

A personal static portfolio site in Jaspr (`mode: static`). Pages pre-render to HTML during
`jaspr build`; `@client` components compile to WebAssembly and hydrate in the browser.
Consult `.claude/skills/`'s Jaspr packs before applying habits from other web frameworks.

## Commands

```bash
just              # list every recipe, grouped
just check        # dart analyze + format + test + tsc --noEmit
just dev          # jaspr build, then wrangler pages dev on :8788
just markers      # the deploy gate
```

`just` and the Jaspr CLI are global installs, not repo dependencies; each recipe is one line of the
`justfile`. `just dev` rebuilds first because `wrangler pages dev` serves the *built* output.

## Comments record constraints, nothing else

A comment in `lib/`, `test/`, `tool/` or `functions/` exists to stop a reader breaking something the
code cannot show them — a server-only assertion, a codegen rule, an emission order, an API whose
units are not what they look like. One or two lines, at the line it explains.

**Why a decision went the way it did belongs in `docs/decisions.md`**, which supersedes the deleted
`docs/landing-page-plan.md` the `D`/`A` identifiers were minted in. Do not restate this file in a doc
comment, and do not open a test file with a paragraph about what it asserts.

## Code runs in two environments

`lib/app.dart` and every file it imports compile **twice** — server (pre-rendering) and client. A
`dart:io` or `dart:html` import anywhere in that graph breaks one of the two builds, which breaks
builds here more often than anything else; branch with `kIsWeb` or split behind a conditional import.
`lib/main.client.options.dart` and `lib/main.server.options.dart` are `jaspr_builder` output — never
edit them.

## Styling

CSS is written in Dart: component-scoped rules in a `@css static List<StyleRule> get styles` getter,
global rules in `lib/constants/theme.dart`. Use the type-safe `css(...)` bindings and shorthand enums
(`display: .flex`), not raw strings, and satisfy `jaspr_lints` rather than suppressing it.

Recurring CSS has names in `theme.dart` — use them rather than re-inlining the literal:
`AppBorders.hairline/hairlineSide` for every 1px line, `AppMotion.ease(property)` for every
transition (`AppMotion.fast` / `slow` are the two durations), `AppGrid.singleColumn` … `fourColumns`
for the equal-column grids, `AppFocus.ring` for the keyboard focus outline, and the global
`.app-container` class for the page's shared gutter and 72rem ceiling. **A caller of
`.app-container` that adds vertical padding must pass `Spacing.symmetric(vertical:)` alone** — both
axes emit the `padding` shorthand, which would overwrite the utility's longhands.

`DESIGN.md`'s YAML frontmatter is the source of truth for tokens; its prose is intent only.
`lib/constants/theme.dart` declares them verbatim (`AppColors`, `AppType`, `AppSpacing`, …). Never
restate a hex value in a component; translucent variants come from `Color.alpha()`.
**Known conflict — the frontmatter wins.** It sets `primary: '#9ecaff'`, the prose names `#0175C2`;
both roles exist, `primary` for text accents and `primary-container` for button fills. And
`docs/reference/landing-page.html`, the archived render, is for layout — **never for colour**.

## All copy lives in one file

Every user-visible string is a field in `lib/content/site_content.dart`; no component declares copy of
its own, so add a string by adding a field there, not in a `build` method.

The real copy has landed — `grep -rn '\[\[TODO:' lib/` now returns nothing. `just markers` stays in
the deploy gate as a guard against a placeholder reappearing, so **the site must not be deployed while
that grep matches**. Plans live in `docs/plans/`, never `lib/` — a plan quoting markers makes that gate
count prose.

Not everything in that file is copy: `ContactFormContent`'s `fieldId`, `scopeFieldId`,
`honeypotName` and `honeypotFieldId` are structural and hold real values, as are `ContactField`'s
`id`, `errorId` and `type` — and a trap carrying a placeholder marker would announce itself to the
scraper it is set for.

## Islands

`CopyEmailButton` and `ContactForm` are the only code running in the browser; `app.dart` is
deliberately not `@client`, since annotating the root would compile and hydrate every section.
**A `@client` component must have an unnamed constructor.** Jaspr's hydration codegen calls one, so a
named one analyzes clean, pre-renders correctly, then fails the client build with `Couldn't find
constructor` — only `jaspr build` catches it. An island also hydrates as its **own tree** and cannot
see the `BlocProvider` above `App`, so both resolve their cubits from `get_it`.

## The contact form owns its own validation

**The `<form>` is `noValidate`, and must stay that way.** Native constraint validation runs *before*
the `submit` event and cancels it, so with `required` fields blank the browser draws its own bubble
and `_onSubmit` never fires — putting validation back would silently disable every message the form
renders. `required`, `aria-required` and `type="email"` stay on the controls: they are the semantics,
nothing styles `:invalid`, and `type="email"` is what gives a phone the `@` key.

Each blocked control carries its own message beneath it, points at it with `aria-describedby`, and a
refused press moves focus to the first one — which is how those messages are announced, and why they
are not live regions. The paragraph above the button is only ever about a failed *send*, and is the
one `role="alert"` on the form.

## State management

`bloc` + `get_it`, with a hand-rolled binding in `lib/state/` (`BlocProvider`, `BlocBuilder`,
`context.read<B>()`). `jaspr_bloc` pins `jaspr: ^0.22.0`; this project is on `^0.23.4`.

- `site_content_repository.dart` is **synchronous and cannot fail** — no I/O behind `const` data, and
  a `Future` would buy a loading state the page can never be in.
- `contact_dispatcher.dart` posts to `/api/contact`: the `Clipboard` seam again, keeping the cubit
  testable on the VM, but with no `kIsWeb` guard — `package:http` uses a conditional import.
- `lib/di/injector.dart` registers everything; `configureDependencies()` is idempotent and runs from
  **both** entrypoints.

**`BlocBuilder` must pass `stream: kIsWeb ? bloc.stream : null`.** `StreamBuilderBase` asserts the
stream is null on the server, where subscribing would schedule rebuilds the static renderer forbids.
A regression fails `jaspr build`, not `dart analyze`.

**`ContactCubit` owns a mutable `ContactDraftBuilder` and never hands it out.** The state carries a
snapshot taken in `_emitDraft`, its one emit path; a mutable builder held *in* an `Equatable` state
would compare equal on every keystroke and suppress the emit — also why `ContactState` has no
`copyWith`. The trap field lives on the builder alone, so typing into it re-renders nothing.

**`CopyCubit` must stay `registerFactory`** — the page renders `CopyEmailButton` twice, and a
singleton would make both confirm on one click.

Every section reads copy through `SiteContentBuilder` (`lib/state/site_content_builder.dart`),
deliberately including ones that freeze at build time — it is `BlocBuilder` with the one-field state
unwrapped, and the islands pass their own cubit to it. `main.server.dart`'s `<head>` is the
exception.

## The contact endpoint

`functions/api/contact.ts` is a Cloudflare Pages Function relaying the form's JSON through Resend.

- **`functions/` is a sibling of `build/jaspr/`, never inside it**, or it stops being a function.
  Wrangler resolves it as `process.cwd()/functions`, never from the assets directory, and no
  `pages deploy` flag overrides that — so the deploy step in `.github/workflows/ci.yml` runs
  from the repo root. Get that wrong and the deploy still succeeds, with a warning, shipping a
  site whose every contact submission 404s.
- **`jaspr serve` does not serve it** — only `just dev` does, on :8788.
- **Secrets are `RESEND_API_KEY`, `CONTACT_TO`, `CONTACT_FROM`** — on the Pages project, in a
  gitignored `.dev.vars` locally, named in `.dev.vars.example`. With any of them missing it answers
  `503` and the form reports the failure, which is correct rather than broken.
- **Status only, no body**: `204` accepted, `400` malformed or a bad address, `429` rate limited,
  `502` Resend refused or timed out, `503` secrets missing. A tripped honeypot also gets `204`, so a
  bot learns nothing from the difference. `HttpContactDispatcher._failureFor` maps each to a
  `DispatchFailure`, which is what the form turns into a sentence — a new status needs a case there
  or it reads as "delivery is down".
- **The reason exists only in the logs.** Failures are `console.error`ed for
  `wrangler pages deployment tail`; the enquiry never is, so nothing in a log line carries the
  visitor's address or their brief.
- **Deployment is direct upload, not a Git connection.** `.github/workflows/ci.yml` builds,
  gates, then runs `wrangler pages deploy build/jaspr --project-name=portfolio --branch=main`.
  Without `--branch` wrangler deploys to production unconditionally; with it, the deployment is
  production only if the string matches the Pages project's own production branch. Preview and
  production hold **separate** secrets, so nothing Resend needs exists on preview.
- **The honeypot is weak here** — the form never natively submits, so a bot posting straight to the
  endpoint never sees it; real abuse needs a challenge at the edge, not more of this.
