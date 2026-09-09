---
name: Kinetic Slate
colors:
  surface: '#0f131c'
  surface-dim: '#0f131c'
  surface-bright: '#353942'
  surface-container-lowest: '#0a0e16'
  surface-container-low: '#181c24'
  surface-container: '#1c2028'
  surface-container-high: '#262a33'
  surface-container-highest: '#31353e'
  on-surface: '#dfe2ee'
  on-surface-variant: '#c0c7d3'
  inverse-surface: '#dfe2ee'
  inverse-on-surface: '#2c3039'
  outline: '#8a919c'
  outline-variant: '#404751'
  surface-tint: '#9ecaff'
  primary: '#9ecaff'
  on-primary: '#003258'
  primary-container: '#0175c2'
  on-primary-container: '#f5f7ff'
  inverse-primary: '#0061a3'
  secondary: '#7ad0ff'
  on-secondary: '#003549'
  secondary-container: '#00a9e3'
  on-secondary-container: '#003a50'
  tertiary: '#00daf3'
  on-tertiary: '#00363d'
  tertiary-container: '#007d8c'
  on-tertiary-container: '#e7fbff'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#d1e4ff'
  primary-fixed-dim: '#9ecaff'
  on-primary-fixed: '#001d36'
  on-primary-fixed-variant: '#00497c'
  secondary-fixed: '#c3e8ff'
  secondary-fixed-dim: '#7ad0ff'
  on-secondary-fixed: '#001e2c'
  on-secondary-fixed-variant: '#004c69'
  tertiary-fixed: '#9cf0ff'
  tertiary-fixed-dim: '#00daf3'
  on-tertiary-fixed: '#001f24'
  on-tertiary-fixed-variant: '#004f58'
  background: '#0f131c'
  on-background: '#dfe2ee'
  surface-variant: '#31353e'
typography:
  display:
    fontFamily: Geist
    fontSize: 56px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: -0.03em
  display-mobile:
    fontFamily: Geist
    fontSize: 38px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.025em
  headline-lg:
    fontFamily: Geist
    fontSize: 36px
    fontWeight: '600'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Geist
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Geist
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-sm:
    fontFamily: Geist
    fontSize: 20px
    fontWeight: '500'
    lineHeight: 28px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Geist
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
    letterSpacing: -0.005em
  body-md:
    fontFamily: Geist
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-sm:
    fontFamily: Geist
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.005em
  code-block:
    fontFamily: JetBrains Mono
    fontSize: 13.5px
    fontWeight: '400'
    lineHeight: 22px
    letterSpacing: 0em
  label-md:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.04em
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 10.5px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.06em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  space-2xs: 0.25rem
  space-xs: 0.5rem
  space-sm: 0.75rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
  space-2xl: 3rem
  space-3xl: 4rem
  gutter-mobile: 1rem
  gutter-desktop: 2rem
  container-max: 72rem
---

## Brand & Style

This design system expresses the precision, architecture, and fluidity of production-grade Flutter and Dart engineering. Geared toward engineering leads, technical recruiters, open-source contributors, and developers, it establishes credibility through architectural rigor and visual craft rather than self-indulgence.

The aesthetic blends **Modern Technical Minimalism** with **Atmospheric Glassmorphism**:
- Deep slate and obsidian backgrounds provide infinite depth, keeping eye fatigue low across prolonged reading and code scrutiny.
- Precise electric blue and cyan accents mirror the core Flutter and Dart toolchain identity, deployed with discipline to indicate interaction, compilation state, and visual hierarchy.
- Micro-surfaces rely on translucent frosted glass treatments, calibrated sub-pixel borders, and subtle luminous edge-highlights that simulate an IDE interface tuned for high performance.

## Colors

The palette leverages a dark-first spectrum optimized for syntax highlighting, contrast compliance, and technical legibility.

- **Primary (`#0175C2`)**: The foundational Flutter brand core. Anchors focal buttons, active tab indicators, and primary branding elements.
- **Secondary (`#40C4FF`)**: Luminous electric blue. Drives primary interactive hover states, active metric counters, key syntax highlights, and glowing terminal badges.
- **Tertiary (`#00E5FF`)**: Vibrant cyan. Reserved for micro-highlights, live compilation badges, architecture diagrams, and high-priority link accents.
- **Neutral Base (`#0B0F17`)**: Deep abyssal slate. Complemented by progressive surface elevations:
  - Surface Ground: `#0B0F17`
  - Surface Subdued (Glass Base): `rgba(15, 23, 42, 0.65)`
  - Surface Elevated: `rgba(24, 34, 53, 0.75)`
  - Surface Border (Ghost Hairline): `rgba(64, 196, 255, 0.12)`
  - Surface Border Active: `rgba(64, 196, 255, 0.35)`
- **Text & Contrast Tokens**:
  - High Emphasis: `#F1F5F9`
  - Medium Emphasis: `#94A3B8`
  - Low Emphasis / Code Comments: `#475569`

## Typography

The typographic system relies on a dual-engine architecture:
- **Geist** handles display titles, section headings, and structured article prose. Its neutral geometry and tight kerning maintain razor-sharp clarity across screen resolutions.
- **JetBrains Mono** governs technical readouts, code snippets, metadata tags, git hash stamps, and widget parameter declarations. Ligatures should be enabled for Dart syntax tokens (`=>`, `==`, `!=`, `::`).

Long-form technical guides must enforce a 68-character line length ceiling on desktop to sustain visual scanning efficiency during multi-step tutorials.

## Layout & Spacing

The layout is built on an **8pt progressive grid** paired with a constrained 12-column system for dashboard layouts and architectural case studies. Long-form technical essays utilize a centralized single-column container flanked by optional sticky table-of-contents rails.

### Breakpoints & Fluid Adaptation
- **Mobile (<640px)**: 4-column flow, `16px` margins, `12px` gutters. Complex multi-step Dart widget trees collapse into interactive tabbed views.
- **Tablet (640px–1024px)**: 8-column flow, `24px` margins, `16px` gutters. Benchmark side-by-side comparisons stack into vertical sequences.
- **Desktop (>1024px)**: 12-column flow locked to a max width of `1152px` (`72rem`). `32px` gutters provide breathing room around dense data tables and embedded Flutter web demos.

## Elevation & Depth

Depth is established through translucent structural layering, diffuse chromatic glows, and razor-sharp ghost borders rather than traditional drop shadows.

- **Base Layer (Ground)**: Solid `#0B0F17` with an optional radial gradient mask of subtle indigo-blue noise at the viewport apex.
- **Level 1 (Card & Snippet Surfaces)**: `rgba(15, 23, 42, 0.65)` with `12px` backdrop blur (`backdrop-filter: blur(12px)`) and a `1px` uniform border of `rgba(64, 196, 255, 0.08)`.
- **Level 2 (Hover & Active Contexts)**: Surface transitions to `rgba(24, 34, 53, 0.85)` with a subtle radial gradient wash (`rgba(1, 117, 194, 0.15)`) trailing cursor movement. Border illuminates to `rgba(64, 196, 255, 0.3)`.
- **Level 3 (Overlays & Modals)**: `rgba(11, 15, 23, 0.85)` with `20px` backdrop blur, framed by a soft diffuse outer glow: `box-shadow: 0 0 32px -8px rgba(64, 196, 255, 0.15)`.

## Shapes

The design system adopts **Soft (Level 1)** geometric profiling. Elements stay crisp and architectural:
- Cards, code terminals, and display panels: `8px` (`0.5rem`).
- Micro-inputs, badges, and inline syntax labels: `4px` (`0.25rem`).
- Interactive status pills and technology tags: Fully rounded pill format (`9999px`) to create distinction between modular tags and structural layout blocks.

## Components

### Buttons
- **Primary**: Solid gradient base (`linear-gradient(135deg, #0175C2 0%, #02569B 100%)`), text in `#F1F5F9`, hairline inner bevel of `rgba(255, 255, 255, 0.2)`. On hover, subtle outer luminescence: `0 0 20px rgba(64, 196, 255, 0.4)`.
- **Secondary (Ghost)**: Glass fill `rgba(64, 196, 255, 0.04)`, border `1px solid rgba(64, 196, 255, 0.2)`, text in `#40C4FF`. Hover shifts fill to `rgba(64, 196, 255, 0.12)`.
- **Monospace Action**: Minimalist button with label font styling, wrapped in brackets e.g. `[ run_demo() ]`.

### Chips & Badges
- **Tech Stack Pills**: JetBrains Mono `label-sm`, `100%` pill border-radius, background `rgba(64, 196, 255, 0.06)`, border `1px solid rgba(64, 196, 255, 0.15)`, text `#40C4FF`.
- **Status Indicator**: Features a `6px` pulsating dot using `#00E5FF` for active or deployed Flutter packages.

### Code Snippets & Syntax Panels
- Styled as miniature IDE windows: includes an obsidian top header bar with file name, file icon, copy buffer button, and branch indicator.
- Window body uses `JetBrains Mono` with dedicated syntax highlighting tokens (Keyword: `#40C4FF`, Class/Widget: `#00E5FF`, String: `#80E9FF`, Comment: `#475569`).

### Project & Architecture Cards
- Frosted glass cards holding dynamic Dart performance metrics (FPS counter, render benchmark).
- Subtle top-border highlight (`1px solid rgba(64, 196, 255, 0.25)` tapering off to the corners).

### Form Controls & Inputs
- Dark slate inputs (`rgba(11, 15, 23, 0.8)`) with `1px` subtle slate border (`rgba(148, 163, 184, 0.15)`).
- On focus: shifts to `#0175C2` border with a `0 0 0 3px rgba(64, 196, 255, 0.15)` focus ring. Placeholder text styled in JetBrains Mono at low emphasis.