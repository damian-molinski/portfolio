# Decisions

Why the code is the way it is. The source carries only the constraints a reader would otherwise
break; the reasoning behind a choice lives here.

`docs/landing-page-plan.md`, which the `D`/`A` identifiers below were minted in, no longer exists.
This file supersedes it. The identifiers are kept because `docs/plans/` still refers to them.

Conventions that are enforced rather than merely decided — the `kIsWeb` stream guard, the `@client`
unnamed constructor, `CopyCubit` as a factory, `.app-container`'s padding longhands — are in
`CLAUDE.md` and are not repeated here.

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

**`SiteContentState` is one class, not a `sealed` hierarchy.** `SiteContentRepository.load()` reads
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
