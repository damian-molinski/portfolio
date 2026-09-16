# Decisions

Why the code is the way it is. The source carries only the constraints a reader would otherwise
break; the reasoning behind a choice lives here.

`docs/landing-page-plan.md`, which the `D`/`A` identifiers below were minted in, no longer exists.
This file supersedes it. The identifiers are kept because `docs/plans/` still refers to them.

Conventions that are enforced rather than merely decided — the `kIsWeb` stream guard, the `@client`
unnamed constructor, `CopyViewModel` as a factory, `.app-container`'s padding longhands — are in
`docs/constraints.md` and are not repeated here.

## Architecture

**Three layers — `data/`, `domain/`, `ui/` — and one ViewModel per view.** Every view that has state
of its own has exactly one ViewModel beside it, under `lib/ui/<feature>/view_model/`. The alternative
was renaming `lib/state/` to `lib/view_models/` in place: smallest diff, but the classes would carry
the MVVM vocabulary while the directory tree still said nothing about layers, and the "ViewModel"
would belong to no view in particular — which is the thing the pattern exists to fix. The Flutter
team's literal `ChangeNotifier` + `Command` MVVM was also rejected: it strands D1 (the hand-rolled
bloc binding, chosen over `jaspr_bloc`) and D4 (cubits, not event-driven blocs) and buys nothing,
because a `Cubit` already *is* a ViewModel.

**Four ViewModels, not one per section.** `AppShellViewModel` serves the chrome, `HomeViewModel` all
six home sections, and the two islands own theirs. D5's reasoning survives the split intact — eight
registrations over `const` data would be ceremony. What the split adds is that each state carries
exactly what its view renders, which is what makes it a ViewModel split rather than a rename. One
shared `SiteContentViewModel` — the old `SiteContentCubit`, moved — was the other option, and the
ViewModel then belongs to no view.

**Copy travels in the emitted state, islands included.** `ContactState` carries `copy` and
`scopeOptions`; `CopyState` carries the four strings the button renders. Each island opens one
`BlocBuilder` rather than a `SiteContentBuilder` nested inside one, and stops importing `SiteContent`
at all — which also ends the oddity of the contact card's copy button reading hero copy. The content
fields are `const`, so Dart canonicalises them and `Equatable` compares by identity; no extra rebuild.
Exposing copy as a plain getter on the ViewModel would keep the state minimal but split the view's
inputs across two access paths, on a page whose stream emits once anyway.

**The router is a `ShellRoute` over one `Route('/')`.** The chrome is provided above the route and
the page content below it, so a second page is a second entry in one list rather than a rewrite of
the shell. A flat `Route(path: '/', builder: …)` returning the whole tree would be fifteen lines of
decoration with no seam behind it. Making the routed subtree `@client` so navigation is real was
rejected against `docs/constraints.md` §State — it ships every section to the browser and buys
nothing on a one-page site.

## Design system

**D3 — the frontmatter palette wins.** `DESIGN.md`'s YAML frontmatter is the source of truth, not
its prose. The design was originally delivered as a Tailwind render whose config carried a
materially darker surface ramp; the built site is lighter than that on purpose, and the surfaces in
`theme.dart` must not be darkened to close a gap with a render that no longer exists here.

**D4 — translucency comes from the role colours.** The original render reached for Tailwind's
`cyan-500/40`, `slate-900/60` and the like. Those collapse onto Kinetic Slate roles at the same
alpha — `AppColors.tertiary.alpha(0.4)` replaces `cyan-500/40` — rather than a second literal
palette being kept alive alongside the first.

**Corner radii.** Also from the frontmatter. The original render's Tailwind config carried a
different, mangled set (its `full` is `0.75rem`); the frontmatter values win.

**A1 — breakpoints are Tailwind's.** `sm` 640, `md` 768, `lg` 1024, which is what the design's
markup keyed off. `DESIGN.md`'s prose describes only 640 and 1024.

**A3 — type steps are mobile-first.** The 56px display step overflows a 360px viewport, so the
mobile variant is the base rule and the desktop step arrives at the breakpoint. Applies to the hero
title and to `SectionHeading`'s `h2`.

**A9 — the primary button's label is `on-primary-container`.** Its fill is the primary *container*
gradient, and the design's darker pairing measured 2.71:1 against it.

**D7 — icons are inline SVG, not a webfont.** The design drives its icons from Material Symbols
Outlined ligatures (`<span class="material-symbols-outlined">send</span>`). `AppIcon` replaces that:
the variable font is a heavy download for twenty-five glyphs, and the ligature-in-a-span pattern
fights both `prefer_html_components` and the type-safe styling API. The geometry is Material
Symbols' own, on its `0 -960 960 960` viewBox (Apache 2.0); glyphs paint with `currentColor` and
size to `1em`, so they track the text beside them exactly as the originals did.

## Layout

**A2 — there is no mobile menu.** The header nav disappears below 768px with nothing replacing it,
mirroring the design rather than inventing one. That makes the footer's link row the only route
between sections at that width, which is why it is a `<nav>` and not a plain row of anchors.

**The signals dock renders the PGP chip once.** The design draws it twice — in the header row for
wide viewports, as a full-width row below the grid for narrow ones — with one hidden at any width.
Rendering it once and reordering it means a screen reader hears the fingerprint a single time.

## State

**The ViewModel states are plain classes, not `sealed` hierarchies.** `SiteContentRepository.load()` reads
`const` data and performs no I/O, so there is no loading state the page can be in and no failure it
can report; the hierarchy had one member and every reader was a single-arm `switch`. What that gives
up: a second case — a runtime content source, say — no longer arrives as an exhaustiveness error at
every call site. It becomes a breaking change at the constructor instead.

**`SiteContentRepository.load()` is synchronous and cannot fail**, for the same reason. Wrapping
`const` data in a `Future` would buy a loading state that can never be observed.

**`BlocProvider` serves only the pre-rendered tree.** The two `@client` islands hydrate as separate
component trees and cannot see anything provided above them, so they resolve from `get_it`. That is
safe only because the content is `const`-backed and deterministic — server and client compute the
same markup from the same literals. A runtime content source would break hydration, and this is the
decision that would have to change first.

## Components

**`MonoButton` has three constructors, not one with a nullable callback.** The element has to
differ: `link` renders an `<a>`, `action` and `submit` render a `<button>`. A single component
taking an optional `onPressed` would compile a handler into the pre-rendered page that nothing can
ever fire, unless the caller sits inside a `@client` boundary.

**The submit button fills its panel**; every other button is shrink-to-fit.

## Toolchain

**Dart 3.13, but not primary constructors.** The SDK floor moved from `^3.10.0` to `^3.13.0` to
match the version CI already pinned. The 3.13 headline feature was the point of the bump and it
turned out to be unreachable: `jaspr_builder` caps `analyzer` at 12.x, where the feature has no
release version, and nothing in `jaspr build` can pass build_runner the experiment flag. Forcing
`analyzer: ^14` through `dependency_overrides` resolves but breaks `dart_style`'s AST visitors, and
the override cascade would reach every builder in the graph. So the enforced default is the half
that does work — private named parameters, with `prefer_initializing_formals` promoted to an error
in `analysis_options.yaml`. The constraint, and the symptom it produces, is in `docs/constraints.md`;
revisit when `jaspr_builder` moves off analyzer 12.

**The wire format is a DTO, not a method on the state class.** `ContactDraft.toJson()` put the shape
of `functions/api/contact.ts` inside the form's state. `ContactDraftDto` carries it in `lib/data/dto/`
instead, next to the dispatcher that posts it, and `json_serializable` generates the encoder. The
DTO is five `String`s — `ScopeOption` is resolved to its value by the mapping extension, so the
generator never learns the enum and the DTO matches the TypeScript `ContactBody` field for field.
No `fromJson`: the endpoint answers with a status and no body, so `createFactory: false`.

## Contact

**The honeypot is weak, and deliberately so.** It catches a scraper that fills every input in the
rendered HTML and replays it. A bot posting straight to `/api/contact` never sees the field, because
the form never natively submits. That is the limit of it; if real abuse arrives, the answer is a
challenge at the edge, not more of this.

**The email pattern is deliberately loose** — an `@` with something either side and a dot in the
domain. `ContactDraftBuilder` and `functions/api/contact.ts` carry the same one, so a `400` means
the same thing on both sides of the wire.

**Field errors are not live regions.** Each blocked control carries its own message beneath it and
points at it with `aria-describedby`; a refused press moves focus to the first one, which is how the
message is announced. Three live regions firing at once would be read as three interruptions. The
paragraph above the button is about a failed *send* rather than any field, nothing focuses it, and
it is the one `role="alert"` on the form.

**The dispatch seam answers a `Result`, not a nullable enum.** `ContactDispatcher.send` returned
`DispatchFailure?`, where `null` meant it arrived — an encoding with nowhere to put success data,
and one the cubit read with an `if` rather than a match. It now returns
`Result<DispatchReceipt, Exception>`: the receipt carries the 2xx the endpoint answered, and the
failure arm carries a sealed `DispatchException` family. `Result` is generic and lives in
`lib/utils/` with two arms and no combinators; `fold`, `map` and the rest arrive when a caller needs
one. The failure type is `Exception` rather than `DispatchException`, so the switch that reads it
needs a fallback arm that `HttpContactDispatcher` can never reach — the price of a seam that can
report something it did not anticipate.

**`DispatchFailure` stays in `lib/ui/contact/view_model/` as the form's vocabulary.** The transport speaks
exceptions; the form speaks four cases it has copy for. `DispatchFailure.of(Exception)` is where one
becomes the other, so `ContactState` stays plainly `Equatable` and `contact_form.dart`'s
`_failureMessage` switch never learns what a `ClientException` is. Two representations of the same
four reasons is the cost; a fifth exception with no copy resolves to `mailer` instead of failing to
compile is the risk that buys.

**Nothing renders `DispatchReceipt.statusCode` yet.** It is on the seam because it exists there and
was previously discarded, not because the page shows it. Putting it on `ContactState` would add a
field with no reader.
