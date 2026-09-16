# Constraints

Rules the code cannot show you, each of which has already been broken once. *Why* a choice went the
way it did is in `docs/decisions.md`; *where* things live is in `docs/topography.md`.

## Builds

**`lib/app.dart` and everything it imports compile twice** — server (pre-rendering) and client. A
`dart:io` or `dart:html` import anywhere in that graph breaks one of the two builds, which breaks
builds here more often than anything else; branch with `kIsWeb` or split behind a conditional import.

**`lib/main.client.options.dart` and `lib/main.server.options.dart` are `jaspr_builder` output** —
never edit them.

**A `@client` component must have an unnamed constructor.** Jaspr's hydration codegen calls one, so a
named one analyzes clean, pre-renders correctly, then fails the client build with `Couldn't find
constructor` — only `jaspr build` catches it.

**`BlocBuilder` must pass `stream: kIsWeb ? bloc.stream : null`.** `StreamBuilderBase` asserts the
stream is null on the server, where subscribing would schedule rebuilds the static renderer forbids.
A regression fails `jaspr build`, not `dart analyze`.

**The site must not be deployed while `grep -rn '\[\[TODO:' lib/` matches.** `just markers` is that
gate. Plans live in `docs/plans/`, never `lib/` — a plan quoting markers makes the gate count prose.

## Styling

CSS is written in Dart: component-scoped rules in a `@css static List<StyleRule> get styles` getter,
global rules in `lib/constants/theme.dart`. Use the type-safe `css(...)` bindings and shorthand enums
(`display: .flex`), not raw strings, and satisfy `jaspr_lints` rather than suppressing it.

Recurring CSS has names in `theme.dart` — use them rather than re-inlining the literal:
`AppBorders.hairline/hairlineSide` for every 1px line, `AppMotion.ease(property)` for every
transition (`AppMotion.fast` / `slow` are the two durations), `AppGrid.singleColumn` …
`fourColumns` for the equal-column grids, `AppFocus.ring` for the keyboard focus outline, and the
global `.app-container` class for the page's shared gutter and 72rem ceiling.

**A caller of `.app-container` that adds vertical padding must pass `Spacing.symmetric(vertical:)`
alone** — both axes emit the `padding` shorthand, which would overwrite the utility's longhands.

**`DESIGN.md`'s YAML frontmatter is the source of truth for tokens**; its prose is intent only.
`lib/constants/theme.dart` declares them verbatim. Never restate a hex value in a component;
translucent variants come from `Color.alpha()`. Known conflict — the frontmatter wins: it sets
`primary: '#9ecaff'`, the prose names `#0175C2`; both roles exist, `primary` for text accents and
`primary-container` for button fills.

## Copy

Every user-visible string is a field in `lib/content/site_content.dart`; no component declares copy
of its own, so add a string by adding a field there, not in a `build` method.

Not everything in that file is copy: `ContactFormContent`'s `fieldId`, `scopeFieldId`,
`honeypotName` and `honeypotFieldId` are structural and hold real values, as are `ContactField`'s
`id`, `errorId` and `type` — a trap carrying a placeholder marker would announce itself to the
scraper it is set for.

Every section reads copy through `SiteContentBuilder`, deliberately including ones that freeze at
build time. `main.server.dart`'s `<head>` is the exception.

## State

`bloc` + `get_it`, with a hand-rolled binding in `lib/state/`. `jaspr_bloc` pins `jaspr: ^0.22.0`;
this project is on `^0.23.4`.

**Islands resolve their cubits from `get_it`, not `BlocProvider`** — `CopyEmailButton` and
`ContactForm` hydrate as their own trees and cannot see the provider above `App`. `app.dart` is
deliberately not `@client`; annotating the root would compile and hydrate every section.

**`ContactCubit` owns a mutable `ContactDraftBuilder` and never hands it out.** The state carries a
snapshot taken in `_emitDraft`, its one emit path; a mutable builder held *in* an `Equatable` state
would compare equal on every keystroke and suppress the emit — also why `ContactState` has no
`copyWith`. The trap field lives on the builder alone, so typing into it re-renders nothing.

**`CopyCubit` must stay `registerFactory`** — the page renders `CopyEmailButton` twice, and a
singleton would make both confirm on one click.

`configureDependencies()` is idempotent and runs from **both** entrypoints.

## The contact form

**The `<form>` is `noValidate`, and must stay that way.** Native constraint validation runs *before*
the `submit` event and cancels it, so with `required` fields blank the browser draws its own bubble
and `_onSubmit` never fires — putting validation back would silently disable every message the form
renders. `required`, `aria-required` and `type="email"` stay on the controls: they are the semantics,
nothing styles `:invalid`, and `type="email"` is what gives a phone the `@` key.

## The contact endpoint

`functions/api/contact.ts` is a Cloudflare Pages Function relaying the form's JSON through Resend.

- **`functions/` is a sibling of `build/jaspr/`, never inside it**, or it stops being a function.
  Wrangler resolves it as `process.cwd()/functions`, never from the assets directory, and no
  `pages deploy` flag overrides that — so the deploy step in `.github/workflows/ci.yml` runs from the
  repo root. Get that wrong and the deploy still succeeds, with a warning, shipping a site whose
  every contact submission 404s.
- **`jaspr serve` does not serve it** — only `just dev` does, on :8788.
- **Secrets are `RESEND_API_KEY`, `CONTACT_TO`, `CONTACT_FROM`** — on the Pages project, in a
  gitignored `.dev.vars` locally, named in `.dev.vars.example`. With any missing it answers `503` and
  the form reports the failure, which is correct rather than broken.
- **Status only, no body**: `204` accepted, `400` malformed or a bad address, `429` rate limited,
  `502` Resend refused or timed out, `503` secrets missing. A tripped honeypot also gets `204`.
  `HttpContactDispatcher._failureFor` maps each to a `DispatchFailure` — a new status needs a case
  there or it reads as "delivery is down".
- **The reason exists only in the logs.** Failures are `console.error`ed for
  `wrangler pages deployment tail`; the enquiry never is, so no log line carries the visitor's
  address or their brief.
- **Deployment is direct upload, not a Git connection.** `.github/workflows/ci.yml` builds, gates,
  then runs `wrangler pages deploy build/jaspr --project-name=portfolio --branch=main`. Without
  `--branch` wrangler deploys to production unconditionally. Preview and production hold **separate**
  secrets, so nothing Resend needs exists on preview.

## Comments

A comment in `lib/`, `test/`, `tool/` or `functions/` exists to stop a reader breaking something the
code cannot show them — a server-only assertion, a codegen rule, an emission order, an API whose
units are not what they look like. One or two lines, at the line it explains. Do not restate this
file in a doc comment, and do not open a test file with a paragraph about what it asserts.
