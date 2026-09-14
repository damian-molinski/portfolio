/// Every user-visible string on the site, in one place.
///
/// **Nothing here is true yet.** Decision D2 ships the page structurally complete and deliberately
/// unlaunchable: each string below is a `[[TODO: …]]` marker that renders literally, so an unfinished
/// site cannot be mistaken for a finished one at a glance or shipped by accident. The design's own
/// wording sits beside each field in a `// was:` comment — filling the site in is a read-and-replace
/// within this file, and no section hardcodes a string in its `build` method.
///
/// The design's copy is not a draft to be tidied up. It asserts things that were never verified —
/// an Impeller shader playground, a PGP fingerprint, an address at a domain nobody owns, software on
/// "tens of millions of devices". Replace a marker only with something true.
///
/// Structural values are the exception and carry their real content: card indices, anchor targets,
/// form control ids and `value` attributes, icon choices, and how many of each thing there are.
library;

import '../components/icons.dart';

/// The marker every unwritten string wears. Grep for it before deploying: `grep -rn '\[\[TODO:' lib/`.
const todoMarker = '[[TODO:';

/// Read by both [SiteIdentity.email] and [ContactCard.directMail]. It is a top-level `const` rather
/// than a member of [SiteIdentity] because an enum constant's arguments must be compile-time
/// constants, and a getter is not one — this keeps the address in exactly one place regardless.
// was: 'damian@molinski.dev'
const _contactEmail = '[[TODO: contact email]]';

/// Identity in the header and the footer.
final class SiteIdentity {
  const SiteIdentity();

  // was: 'Damian Moliński'
  String get name => '[[TODO: full name]]';

  // was: 'Flutter & Dart Systems Architect'
  String get role => '[[TODO: role strapline]]';

  // was: '© Damian Moliński • Systems Architecture & Impeller Internals'
  String get copyright => '[[TODO: copyright line]]';

  /// The address both copy buttons write to the clipboard.
  String get email => _contactEmail;

  /// The header's avatar. D6 keeps the slot and drops the image: the portrait shipped in the design
  /// was an AI-generated likeness of someone else, and no real one exists yet. Until it does, the
  /// slot renders its ring and initials rather than a face.
  // was: an expiring lh3.googleusercontent.com portrait
  String get avatarAlt => '[[TODO: portrait]]';

  /// The site's own emblem: the transparent crop of the tile archived out of the design.
  ///
  /// `emblem-1024.png` beside it is the opaque master the PWA icons and the favicon were generated
  /// from. That master carries its own near-black ground, which would render as a dark square in the
  /// header, so the header uses this cut-out instead.
  String get emblem => '/images/emblem.png';

  // was: 'Brand logo. - Primary color: #0175c2 - Font: geist - Mode: dark - Roundness: rounded-sm'
  String get emblemAlt => '[[TODO: emblem alt text]]';
}

/// `<head>` metadata.
///
/// The canonical domain is unresolved (an open question on the plan) and no social preview image
/// exists, so those ship as markers too — see assumption A6.
final class SiteMeta {
  const SiteMeta();

  String get title => '[[TODO: page title]]';
  String get description => '[[TODO: meta description]]';
  String get ogTitle => '[[TODO: og:title]]';
  String get ogDescription => '[[TODO: og:description]]';
  String get ogImage => '[[TODO: og:image absolute URL]]';
  String get canonical => '[[TODO: canonical URL]]';
  String get twitterSite => '[[TODO: @handle]]';

  /// Structural, not copy: taken from the manifest archived out of the design.
  String get themeColor => '#0175c2';
  String get manifest => '/manifest.json';
  String get locale => 'en';
}

/// The four numbered sections, in the order they appear.
///
/// Anchors and ordinals are structural and real; every heading is a marker. The header nav and the
/// footer both link here rather than repeating the hrefs.
enum SiteSection {
  pillars(
    ordinal: '01',
    anchor: '#pillars',
    // was: 'Core Competencies'
    eyebrow: '[[TODO: section 01 eyebrow]]',
    // was: 'Architectural Pillars'
    title: '[[TODO: section 01 heading]]',
    // was: 'Focus & Architecture Pillars'
    ariaLabel: '[[TODO: section 01 landmark label]]',
    // was: 'Pillars'
    navLabel: '[[TODO: nav 01]]',
  ),
  skills(
    ordinal: '02',
    anchor: '#skills',
    // was: 'Technical Capabilities'
    eyebrow: '[[TODO: section 02 eyebrow]]',
    // was: 'Skills & Tech Stack'
    title: '[[TODO: section 02 heading]]',
    // was: 'Skills & Tech Stack'
    ariaLabel: '[[TODO: section 02 landmark label]]',
    // was: 'Skills'
    navLabel: '[[TODO: nav 02]]',
    // was: 'Engine-level internals, compiler toolchains, and high-throughput architectural patterns.'
    lead: '[[TODO: section 02 standfirst — one line, sets up the four groups below]]',
    // was: 'Engine Depth · Production Hardened'
    note: '[[TODO: section 02 note]]',
  ),
  projects(
    ordinal: '03',
    anchor: '#projects',
    // was: 'Featured Artifacts'
    eyebrow: '[[TODO: section 03 eyebrow]]',
    // was: 'Projects & Case Studies'
    title: '[[TODO: section 03 heading]]',
    // was: 'Projects & Case Studies'
    ariaLabel: '[[TODO: section 03 landmark label]]',
    // was: 'Projects'
    navLabel: '[[TODO: nav 03]]',
    // was: 'Production graphics engines, native audio pipelines, and enterprise systems architecture.'
    lead: '[[TODO: section 03 standfirst]]',
    // was: '3 Production Artifacts Active'
    note: '[[TODO: section 03 note]]',
  ),
  contact(
    ordinal: '04',
    anchor: '#contact',
    // was: 'Direct Touchpoint'
    eyebrow: '[[TODO: section 04 eyebrow]]',
    // was: "Let's Talk"
    title: '[[TODO: section 04 heading]]',
    // was: 'Contact & Consultation'
    ariaLabel: '[[TODO: section 04 landmark label]]',
    // was: 'Consultation'
    navLabel: '[[TODO: nav 04]]',
  );

  const SiteSection({
    required this.ordinal,
    required this.anchor,
    required this.eyebrow,
    required this.title,
    required this.ariaLabel,
    required this.navLabel,
    this.lead,
    this.note,
  });

  /// The two-digit index the design prints in the eyebrow. Structural.
  final String ordinal;

  /// The in-page target, used by the nav, the footer and the hero's primary call to action.
  final String anchor;

  final String eyebrow;
  final String title;

  /// Names the `<section>` landmark for screen readers.
  final String ariaLabel;

  /// How the header nav and footer refer to this section.
  final String navLabel;

  /// An optional standfirst under the heading. Absent on the sections that do not have one.
  final String? lead;

  /// An optional right-aligned status note; hidden below 640px.
  final String? note;

  /// The eyebrow as the design prints it, `01 • Core Competencies`.
  String get eyebrowLine => '$ordinal • $eyebrow';

  /// The `id` the section's element carries, which is [anchor] without its leading `#`.
  String get id => anchor.substring(1);
}

/// The hero, section `00`.
final class HeroContent {
  const HeroContent();

  // was: 'Staff Flutter & Systems Architect'
  String get statusPill => '[[TODO: role badge]]';

  /// The headline is split so the second half can take the gradient treatment the design gives it.
  // was: 'Damian'
  String get headlineLead => '[[TODO: first name]]';

  // was: 'Moliński'
  String get headlineAccent => '[[TODO: surname]]';

  // was: 'Architecting sub-millisecond render pipelines, cross-platform Dart FFI runtimes, and
  //       fault-tolerant graphics systems.'
  String get tagline => '[[TODO: hero tagline — one sentence, what you build]]';

  // was: 'Specialized in low-level Flutter Engine internals, Impeller custom fragment shaders,
  //       native C++ interop, and mission-critical multi-platform architectures deployed to tens of
  //       millions of devices.'
  String get body => '[[TODO: hero paragraph — two or three lines of substantiated detail]]';

  // was: '[ start_inquiry() ]'
  String get primaryCta => '[[TODO: primary CTA label]]';

  // was: 'Start consultation inquiry, jump to contact section'
  String get primaryCtaAriaLabel => '[[TODO: primary CTA accessible name]]';

  // was: 'copy damian@molinski.dev'
  String get copyCta => '[[TODO: copy-email CTA label]]';

  // was: 'Copy email address damian@molinski.dev to clipboard'
  String get copyCtaAriaLabel => '[[TODO: copy-email accessible name]]';

  /// Shown for two seconds after a successful clipboard write.
  // was: 'copied!'
  String get copyCtaSuccess => '[[TODO: copied confirmation]]';

  // was: 'Status: Q3/Q4 Advisory Slots Open'
  String get availability => '[[TODO: availability status]]';

  // was: 'Remote / EMEA / US PST'
  String get locations => '[[TODO: working timezones]]';
}

/// The frosted identity dock that overlaps the bottom of the hero.
final class SignalsContent {
  const SignalsContent();

  // was: 'Identity & Signals'
  String get title => '[[TODO: dock heading]]';

  // was: 'verified_nodes'
  String get subtitle => '[[TODO: dock subtitle]]';

  // was: 'PGP: 4A8F B12D 99C3 0E1F'
  String get pgpFingerprint => '[[TODO: PGP fingerprint, or delete this chip]]';

  // was: 'ED25519'
  String get pgpAlgorithm => '[[TODO: PGP key algorithm]]';
}

/// The verified identity links in the signals dock.
///
/// **Unresolved:** `pubspec.yaml` says `github.com/damian-molinski` (hyphenated) while every link in
/// the design said `damianmolinski` (unhyphenated). At least one is wrong, so both stay markers and
/// neither is guessed — see the plan's open questions.
enum IdentityNode {
  github(
    icon: AppIcon.code,
    trailing: AppIcon.northEast,
    // was: 'GitHub'
    name: '[[TODO: GitHub]]',
    // was: '@damianmolinski'
    handle: '[[TODO: GitHub handle]]',
    // was: 'https://github.com/damianmolinski'
    href: '[[TODO: GitHub URL]]',
    // was: 'Damian Moliński on GitHub (@damianmolinski)'
    ariaLabel: '[[TODO: GitHub accessible name]]',
  ),
  linkedin(
    icon: AppIcon.terminal,
    trailing: AppIcon.northEast,
    // was: 'LinkedIn'
    name: '[[TODO: LinkedIn]]',
    // was: 'in/damianmolinski'
    handle: '[[TODO: LinkedIn handle]]',
    // was: 'https://linkedin.com/in/damianmolinski'
    href: '[[TODO: LinkedIn URL]]',
    // was: 'Damian Moliński on LinkedIn (in/damianmolinski)'
    ariaLabel: '[[TODO: LinkedIn accessible name]]',
  ),
  x(
    icon: AppIcon.tag,
    trailing: AppIcon.northEast,
    // was: 'X / Twitter'
    name: '[[TODO: X]]',
    // was: '@damianmolinski'
    handle: '[[TODO: X handle]]',
    // was: 'https://x.com/damianmolinski'
    href: '[[TODO: X URL]]',
    // was: 'Damian Moliński on X (@damianmolinski)'
    ariaLabel: '[[TODO: X accessible name]]',
  ),
  pubDev(
    icon: AppIcon.hub,
    // The one node whose trailing glyph is a verification tick rather than an outbound arrow.
    trailing: AppIcon.checkCircle,
    // was: 'Pub.dev'
    name: '[[TODO: pub.dev]]',
    // was: 'Verified Publisher'
    handle: '[[TODO: publisher status]]',
    // was: 'https://pub.dev/publishers/damianmolinski.dev/packages'
    href: '[[TODO: pub.dev publisher URL]]',
    // was: 'Damian Moliński on Pub.dev (Verified Publisher)'
    ariaLabel: '[[TODO: pub.dev accessible name]]',
  );

  const IdentityNode({
    required this.icon,
    required this.trailing,
    required this.name,
    required this.handle,
    required this.href,
    required this.ariaLabel,
  });

  final AppIcon icon;

  /// The glyph in the top-right corner of the tile.
  final AppIcon trailing;

  final String name;
  final String handle;
  final String href;
  final String ariaLabel;
}

/// What the pillars and skills cards both render.
///
/// The two sections are the same card with different data: a glyph in a tile, an index opposite it,
/// a heading, a paragraph, and a row of tags. Naming that shape lets one component draw both, and
/// says the resemblance is intended rather than accidental.
abstract interface class SpecEntry {
  /// Where the card sits in its row. Both implementers are enums, so this comes for free, and the
  /// accent ramp across the row is derived from it.
  int get index;

  AppIcon get icon;

  /// The mono index printed opposite the glyph — `01/04` for a pillar, `STK/01` for a skill group.
  String get indexLabel;

  String get title;
  String get body;
  List<String> get tags;
}

/// Section `01` — the four competency cards.
///
/// The `NN/04` index is structural. Everything else is a claim and stays a marker.
enum Pillar implements SpecEntry {
  first(
    icon: AppIcon.draw,
    indexLabel: '01/04',
    // was: 'Impeller & Shaders'
    title: '[[TODO: pillar 1 title]]',
    // was: 'Custom GLSL fragment shaders, pipeline caching, tessellation tuning, and Vulkan/Metal
    //       backend optimization for stable 120 FPS render loops.'
    body: '[[TODO: pillar 1 body — two lines on what you actually do here]]',
    // was: ['SPIR-V', 'Impeller', 'SkSL Fixes']
    tags: ['[[TODO: tag]]', '[[TODO: tag]]', '[[TODO: tag]]'],
  ),
  second(
    icon: AppIcon.memory,
    indexLabel: '02/04',
    // was: 'Dart Native & C++ FFI'
    title: '[[TODO: pillar 2 title]]',
    // was: 'Bypassing platform channels via zero-copy FFI memory pointers, native C++ audio/crypto
    //       engines, and custom isolate thread pools.'
    body: '[[TODO: pillar 2 body]]',
    // was: ['dart:ffi', 'C++20', 'Zero-Copy']
    tags: ['[[TODO: tag]]', '[[TODO: tag]]', '[[TODO: tag]]'],
  ),
  third(
    icon: AppIcon.speed,
    indexLabel: '03/04',
    // was: 'Runtime Profiling'
    title: '[[TODO: pillar 3 title]]',
    // was: 'Deep tracing via DevTools CPU samplers, memory leak elimination in long-running kiosk
    //       runtimes, raster thread micro-benchmarks.'
    body: '[[TODO: pillar 3 body]]',
    // was: ['Frame Timings', 'Memory Heap', 'AOT Tracing']
    tags: ['[[TODO: tag]]', '[[TODO: tag]]', '[[TODO: tag]]'],
  ),
  fourth(
    icon: AppIcon.architecture,
    indexLabel: '04/04',
    // was: 'System Audits & Core'
    title: '[[TODO: pillar 4 title]]',
    // was: 'Advising scale-ups and enterprises on multi-repo monorepo structures, custom
    //       code-generation tools, and compile-time state containers.'
    body: '[[TODO: pillar 4 body]]',
    // was: ['Macro Systems', 'Melos', 'Code Review']
    tags: ['[[TODO: tag]]', '[[TODO: tag]]', '[[TODO: tag]]'],
  );

  const Pillar({
    required this.icon,
    required this.indexLabel,
    required this.title,
    required this.body,
    required this.tags,
  });

  @override
  final AppIcon icon;

  /// Structural: the card's position in the set, not copy.
  @override
  final String indexLabel;

  @override
  final String title;

  @override
  final String body;

  @override
  final List<String> tags;
}

/// Section `02` — the four capability groups, five tags each.
enum SkillGroup implements SpecEntry {
  first(
    icon: AppIcon.terminal,
    indexLabel: 'STK/01',
    // was: 'Systems & Runtimes'
    title: '[[TODO: stack group 1 title]]',
    // was: 'Core runtime architectures, native embedders, and cross-boundary low-latency memory
    //       execution.'
    body: '[[TODO: stack group 1 body]]',
    // was: ['Flutter Engine C++', 'Dart 3 AOT / JIT', 'C++20 FFI', 'Linux/macOS Native Embedders',
    //       'Zero-Copy Shared Memory']
    tags: ['[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]'],
  ),
  second(
    icon: AppIcon.palette,
    indexLabel: 'STK/02',
    // was: 'Graphics & Shaders'
    title: '[[TODO: stack group 2 title]]',
    // was: 'GPU compute pipelines, modern shader toolchains, and hardware acceleration layer mastery.'
    body: '[[TODO: stack group 2 body]]',
    // was: ['Impeller Rendering Pipeline', 'GLSL / SPIR-V Shaders', 'Vulkan & Metal APIs',
    //       'Tessellation & Pipeline Caching', 'Custom Render Loops']
    tags: ['[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]'],
  ),
  third(
    icon: AppIcon.monitoring,
    indexLabel: 'STK/03',
    // was: 'Diagnostics & Profiling'
    title: '[[TODO: stack group 3 title]]',
    // was: 'Zero-overhead telemetry, memory allocation tracking, and raster thread latency
    //       regression hunting.'
    body: '[[TODO: stack group 3 body]]',
    // was: ['DevTools CPU Profiling', 'Memory Heap & Leak Analysis', 'Raster Thread Tracing',
    //       'Micro-benchmarks', 'Frame Budget Allocation']
    tags: ['[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]'],
  ),
  fourth(
    icon: AppIcon.accountTree,
    indexLabel: 'STK/04',
    // was: 'Tooling & Scale'
    title: '[[TODO: stack group 4 title]]',
    // was: 'Monorepo orchestration, deterministic build graphs, and cryptographically verified
    //       supply chains.'
    body: '[[TODO: stack group 4 body]]',
    // was: ['Melos Monorepos', 'Custom Code Generation', 'CI/CD Pipeline Automation',
    //       'Deterministic Builds', 'Supply Chain & PGP Audits']
    tags: ['[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]', '[[TODO: skill]]'],
  );

  const SkillGroup({
    required this.icon,
    required this.indexLabel,
    required this.title,
    required this.body,
    required this.tags,
  });

  @override
  final AppIcon icon;

  /// Structural: the card's position in the set, not copy.
  @override
  final String indexLabel;

  @override
  final String title;

  @override
  final String body;

  @override
  final List<String> tags;
}

/// Section `03` — the three case-study cards.
///
/// Every one of these was fiction in the design, telemetry figures included. A project only goes back
/// in here once it exists and its numbers can be defended.
enum Project {
  first(
    // was: '01 // GRAPHICS & ENGINE'
    category: '[[TODO: project 1 category]]',
    // was: 'Impeller Shader Playground & Inspector'
    title: '[[TODO: project 1 title]]',
    // was: "Interactive SPIR-V shader workbench and runtime telemetry profiler for Flutter's
    //       next-gen graphics backend."
    body: '[[TODO: project 1 description]]',
    // was: '120 FPS target · Zero SkSL hitching · Vulkan/Metal backend'
    telemetry: '[[TODO: project 1 measured results]]',
    // was: ['Impeller', 'GLSL', 'Vulkan', 'C++20']
    tags: ['[[TODO: tag]]', '[[TODO: tag]]', '[[TODO: tag]]', '[[TODO: tag]]'],
    // was: '#'
    href: '[[TODO: project 1 URL]]',
  ),
  second(
    // was: '02 // NATIVE SYSTEMS'
    category: '[[TODO: project 2 category]]',
    // was: 'Dart FFI Zero-Copy Audio DSP Engine'
    title: '[[TODO: project 2 title]]',
    // was: 'Sub-millisecond audio synthesis pipeline bypassing standard platform channels via
    //       direct memory pointers and worker isolate pools.'
    body: '[[TODO: project 2 description]]',
    // was: '< 1.2ms latency · Zero GC pause · SIMD acceleration'
    telemetry: '[[TODO: project 2 measured results]]',
    // was: ['dart:ffi', 'C++20', 'SIMD', 'Isolates']
    tags: ['[[TODO: tag]]', '[[TODO: tag]]', '[[TODO: tag]]', '[[TODO: tag]]'],
    // was: '#'
    href: '[[TODO: project 2 URL]]',
  ),
  third(
    // was: '03 // ARCHITECTURE & DEVOPS'
    category: '[[TODO: project 3 category]]',
    // was: 'Enterprise Melos Monorepo Framework'
    title: '[[TODO: project 3 title]]',
    // was: 'Modular architecture blueprint powering 60+ interdependent Dart/Flutter packages with
    //       distributed remote caching.'
    body: '[[TODO: project 3 description]]',
    // was: '4.5x faster CI pipeline · 100% deterministic builds'
    telemetry: '[[TODO: project 3 measured results]]',
    // was: ['Melos', 'Monorepo', 'Codegen', 'DevOps']
    tags: ['[[TODO: tag]]', '[[TODO: tag]]', '[[TODO: tag]]', '[[TODO: tag]]'],
    // was: '#'
    href: '[[TODO: project 3 URL]]',
  );

  const Project({
    required this.category,
    required this.title,
    required this.body,
    required this.telemetry,
    required this.tags,
    required this.href,
  });

  final String category;
  final String title;
  final String body;

  /// The figures in the card's readout box.
  final String telemetry;

  final List<String> tags;
  final String href;

  /// What the card's link is called out of context, where three identical "View Project" links are
  /// indistinguishable.
  String get linkAriaLabel => '${const ProjectContent().viewLabel}: $title';
}

/// Copy shared by the projects section's cards.
final class ProjectContent {
  const ProjectContent();

  // was: 'Active'
  String get activeLabel => '[[TODO: status label]]';

  // was: 'Telemetry & Target'
  String get telemetryLabel => '[[TODO: telemetry box label]]';

  // was: 'View Project'
  String get viewLabel => '[[TODO: project link label]]';
}

/// Section `04` — the three summary cards above the form.
enum ContactCard {
  directMail(
    icon: AppIcon.mail,
    // was: 'Direct Mail'
    label: '[[TODO: direct mail card label]]',
    // Rendered from the same address SiteIdentity.email and the copy button use.
    value: _contactEmail,
  ),
  responseSla(
    icon: AppIcon.timer,
    // was: 'Response SLA'
    label: '[[TODO: response SLA card label]]',
    // was: '≤ 24 hours for technical briefs'
    value: '[[TODO: response time you will actually hold to]]',
  ),
  secureTransmission(
    icon: AppIcon.lock,
    // was: 'Secure Transmission'
    label: '[[TODO: secure transmission card label]]',
    // was: 'Key ID: 0x99C30E1F (keys.openpgp.org)'
    value: '[[TODO: PGP key ID, or delete this card]]',
  );

  const ContactCard({required this.icon, required this.label, required this.value});

  final AppIcon icon;
  final String label;
  final String value;

  /// Where the card's value points, for the one card whose value is an address. Null elsewhere.
  String? get href => this == directMail ? 'mailto:$value' : null;

  /// Whether the card offers the clipboard copy the hero's second call to action also offers.
  bool get isCopyable => this == directMail;
}

/// The dispatch form's text controls.
///
/// Ids and input types are structural — they wire `<label for>` to its control and pick the mobile
/// keyboard — so they carry their real values. So are the enum identifiers: each one is the `name`
/// the control submits under, read back through `Enum.name`.
enum ContactField {
  name(
    id: 'contact-name',
    type: 'text',
    autocomplete: 'organization',
    // was: 'Your Name / Organization'
    label: '[[TODO: name field label]]',
    // was: 'e.g. Alex Vance, Acme Corp'
    placeholder: '[[TODO: name field example]]',
  ),
  email(
    id: 'contact-email',
    type: 'email',
    autocomplete: 'email',
    // was: 'Email Address'
    label: '[[TODO: email field label]]',
    // was: 'name@domain.com'
    placeholder: '[[TODO: email field example]]',
  ),
  brief(
    id: 'contact-brief',
    type: 'textarea',
    autocomplete: 'off',
    // was: 'Project Brief'
    label: '[[TODO: brief field label]]',
    // was: 'Overview of target bottleneck, timeline, and current Dart/Flutter runtime stack...'
    placeholder: '[[TODO: brief field prompt]]',
  );

  const ContactField({
    required this.id,
    required this.type,
    required this.autocomplete,
    required this.label,
    required this.placeholder,
  });

  /// Ties the control to its `<label for>`. Structural.
  final String id;

  /// `text`, `email`, or the sentinel `textarea` for the one control that is not an `<input>`.
  final String type;

  final String autocomplete;
  final String label;
  final String placeholder;

  /// Every field on this form is required; the design marks all three.
  bool get isRequired => true;

  /// Whether this field wants the email keyboard and the browser's address validation.
  bool get isEmail => type == 'email';

  /// Whether this field renders as a `<textarea>` rather than an `<input>`.
  bool get isMultiline => type == 'textarea';
}

/// The engagement-scope dropdown.
///
/// The submitted `value` is structural and real; the visible label is copy.
///
/// Note that `docs/prd.md` §3.7 lists only four options — the rendered design has these five, and it
/// is the PRD that is stale.
enum ScopeOption {
  // was: 'Architecture / Performance Audit'
  audit('[[TODO: scope option 1]]'),
  // was: 'Custom Impeller / Shader Engineering'
  shaders('[[TODO: scope option 2]]'),
  // was: 'Native C++ / Rust FFI Implementation'
  ffi('[[TODO: scope option 3]]'),
  // was: 'Fractional Staff Architect Role'
  fractional('[[TODO: scope option 4]]'),
  // was: 'General Technical Inquiry'
  other('[[TODO: scope option 5]]');

  const ScopeOption(this.label);

  final String label;

  String get value => name;

  /// The option carrying [value], for reading a `<select>`'s state back into the enum.
  static ScopeOption byValue(String value) => ScopeOption.values.byName(value);
}

/// The dispatch form's own chrome.
final class ContactFormContent {
  const ContactFormContent();

  String get fieldId => 'contact-form';
  String get scopeFieldId => 'contact-scope';

  // was: 'Engagement Scope'
  String get scopeLabel => '[[TODO: scope field label]]';

  // was: '(required)'
  String get requiredHint => '[[TODO: required marker]]';

  // was: '[ dispatch_message() ]'
  String get submitLabel => '[[TODO: submit button label]]';

  /// Shown while the submit sequence runs.
  // was: 'Transmitting...'
  String get submittingLabel => '[[TODO: submitting label]]';

  /// Shown once the sequence finishes.
  // was: '[ sent_successfully ]'
  String get submittedLabel => '[[TODO: sent confirmation]]';

  /// Shown when a required field is empty on submit.
  String get validationMessage => '[[TODO: validation message]]';

  /// Shown when the send itself failed. The design had no failure state at all — its submit always
  /// succeeded, because nothing was behind it.
  String get failureMessage => '[[TODO: send failure message]]';

  /// The trap field's `name` and `id`. Structural for the same reason, and unmarked for a second
  /// one: a trap carrying a placeholder marker would announce itself to the scraper it is set for.
  String get honeypotName => 'company';
  String get honeypotFieldId => 'contact-company';
}

/// The footer's link row.
///
/// Four of the five point at the sections above; `about` had no destination in the design either.
enum FooterLink {
  about(
    // was: 'About'
    label: '[[TODO: footer link 1]]',
    // was: '#'
    href: '[[TODO: about URL, or delete this link]]',
  ),
  // was: 'Focus' — the design labels the pillars section differently down here than in the nav
  focus(label: '[[TODO: footer link 2]]', href: '#pillars'),
  // was: 'Skills'
  skills(label: '[[TODO: footer link 3]]', href: '#skills'),
  // was: 'Projects'
  projects(label: '[[TODO: footer link 4]]', href: '#projects'),
  // was: 'Contact'
  contact(label: '[[TODO: footer link 5]]', href: '#contact');

  const FooterLink({required this.label, required this.href});

  final String label;
  final String href;
}

/// Strings that belong to the page frame rather than to any one section.
final class ChromeContent {
  const ChromeContent();

  // was: 'Skip to main content'
  String get skipLink => '[[TODO: skip link label]]';

  /// Names the `<main>` landmark and is the skip link's target. Structural.
  String get mainId => 'main-content';

  /// [mainId] as the skip link's `href`.
  String get mainAnchor => '#$mainId';

  // was: 'About Damian Moliński'
  String get avatarAriaLabel => '[[TODO: avatar link accessible name]]';

  /// Fills the empty avatar ring until a real portrait exists (D6). Structural rather than copy —
  /// the marker that keeps this from shipping silently is [avatarAriaLabel], which names the slot.
  String get avatarPlaceholder => '?';
}
