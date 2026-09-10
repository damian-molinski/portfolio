# Frozen design reference

These files are a **frozen reference, not a build input.** Nothing in `lib/` or `web/` reads from this
directory, and nothing here is served. They exist so the design survives the deletion of `design/`,
which was untracked and has now been removed.

| File | What it is | Where it came from |
| --- | --- | --- |
| `landing-page.html` | The rendered Kinetic Slate landing page, 644 lines, Tailwind-based. The precise reference — open it in a browser when a detail matters. | `design/stitch_flutter_developer_portfolio_blog_damian/damian_moli_ski_landing_page_with_skills_projects/code.html` |
| `landing-page.png` | Full-page render, 606×1600. Low resolution — adequate for structural comparison, not for pixel work. | the `screen.png` beside that `code.html` |
| `../prd.md` | The product brief. Largely aspirational; see below. | `design/project_brief_prd_damian_moli_ski_portfolio.md` |

## Read these with three corrections

**1. The palette in `landing-page.html` is superseded.** Its inline `tailwind.config` overrides the
surface ramp with a darker "Obsidian Glow" set, and this screenshot shows that darker version. The
implementation follows `DESIGN.md`'s frontmatter instead, per decision **D3** in
[`../landing-page-plan.md`](../landing-page-plan.md), so the built site is visibly lighter than what
you see here. That is deliberate. Do not darken the surfaces to close the gap.

| Token | Implemented (`DESIGN.md`) | Shown here (`landing-page.html`) |
| --- | --- | --- |
| `surface` / `background` / `surface-dim` | `#0f131c` | `#05070d` |
| `surface-container-lowest` | `#0a0e16` | `#030408` |
| `surface-container-low` | `#181c24` | `#0b0f17` |
| `surface-container` | `#1c2028` | `#141923` |
| `surface-container-high` | `#262a33` | `#1f2533` |
| `surface-container-highest` / `surface-variant` | `#31353e` | `#283040` |

Everything else — primary, secondary, tertiary, the type scale, spacing, radii — is identical in both.

**2. The copy is not true.** The PRD and the HTML both carry claims that were never verified: the
Impeller shader playground, the PGP fingerprint, `damian@molinski.dev`, "tens of millions of devices",
"60+ interdependent packages". The implementation ships every string as a `[[TODO: …]]` marker with
the original wording preserved in a `// was:` comment (decision **D2**). Treat the wording here as
layout ballast — it tells you how long a line should be, not what it should say.

**3. The images are gone.** Every `<img src>` in the HTML points at an
`lh3.googleusercontent.com/aida/…` URL that has expired or will. The emblem survives as
`web/images/emblem-1024.png`; the headshot was an AI-generated portrait of someone who is not Damian
and was deliberately not kept (decision **D6**).

One more discrepancy, minor: PRD §3.7 lists four engagement-scope options for the contact form.
`landing-page.html` has five (`audit`, `shaders`, `ffi`, `fractional`, `other`). The HTML is correct;
the PRD is stale.
