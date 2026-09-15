library;

import '../components/icons.dart';

const _contactEmail = 'contact@damian-molinski.dev';

/// Identity in the header and the footer.
final class SiteIdentity {
  const SiteIdentity();

  String get name => 'Damian Moliński';
  String get role => 'Team Lead & Flutter Software Engineer';
  String get copyright => '© Damian Moliński • Build with Flutter';
  String get email => _contactEmail;
  String get avatarAlt => 'Portrait photo';
  String get emblem => '/images/emblem.png';
  String get emblemAlt => 'Logo';
}

/// `<head>` metadata.
final class SiteMeta {
  const SiteMeta();

  String get title => 'Damian Moliński - Portfolio Website';
  String get description =>
      'Damian Moliński — Team Lead and Flutter software engineer. Multi-platform apps from one codebase: '
      'mobile, web, desktop and backend, with Rust FFI, SQLite and runtime profiling.';
  String get ogTitle => 'Damian Moliński — Team Lead & Flutter Software Engineer';
  String get ogDescription =>
      'Multi-platform product engineering from one codebase — mobile, web, desktop and backend.';
  String get ogImage => 'https://damian-molinski.dev/images/og-cover.jpg';
  String get canonical => 'https://damian-molinski.dev/';
  String get twitterSite => '@DamianMoliski12';

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
    eyebrow: 'Core Competencies',
    title: 'Architectural Pillars',
    ariaLabel: 'Focus & Architecture Pillars',
    navLabel: 'Pillars',
  ),
  skills(
    ordinal: '02',
    anchor: '#skills',
    eyebrow: 'Technical Capabilities',
    title: 'Skills & Tech Stack',
    ariaLabel: 'Skills & Tech Stack',
    navLabel: 'Skills',
    lead: 'True multi-platform Flutter development, from mobile to web and desktop — plus backend behind it.',
    note: 'This site was built with Flutter.',
  ),
  projects(
    ordinal: '03',
    anchor: '#projects',
    eyebrow: 'Featured Artifacts',
    title: 'Projects',
    ariaLabel: 'Projects',
    navLabel: 'Projects',
    lead:
        'Production audio & video pipelines, cryptography, fintech, enterprise systems architecture and web3 '
        'platforms.',
  ),
  contact(
    ordinal: '04',
    anchor: '#contact',
    eyebrow: 'Direct',
    title: 'Let\'s Talk',
    ariaLabel: 'Contact',
    navLabel: 'Contact',
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

  final String ordinal;
  final String anchor;
  final String eyebrow;
  final String title;
  final String ariaLabel;
  final String navLabel;
  final String? lead;
  final String? note;
  String get eyebrowLine => '$ordinal • $eyebrow';

  String get id => anchor.substring(1);
}

/// The hero, section `00`.
final class HeroContent {
  const HeroContent();

  String get statusPill => 'Team Lead & Flutter Software Engineer';
  String get headlineLead => 'Damian';
  String get headlineAccent => 'Moliński';

  String get tagline =>
      'Solving real problems and building scalable systems for every platform and form factor. From one codebase.';

  String get body =>
      'Specialised in mobile software engineering, web and desktop. Building solutions tailored to '
      'the problem: SQLite and Rust FFI where performance decides it, shared Dart everywhere else, '
      'profiling and CI holding the line — one codebase, every platform.';

  String get primaryCta => '[ lets_talk() ]';
  String get primaryCtaAriaLabel => 'Let\'t talk, jump to contact section';
  String get copyCta => 'copy $_contactEmail';
  String get copyCtaAriaLabel => 'Copy email address $_contactEmail to clipboard';
  String get copyCtaSuccess => 'copied!';
  String get availability => 'Status: contact FiveDotTwelve';
  String get locations => 'Remote / PL';
}

/// The frosted identity dock that overlaps the bottom of the hero.
final class SignalsContent {
  const SignalsContent();
  String get title => 'Identity & Signals';
  String get subtitle => 'verified_nodes';

  String get pgpFingerprint => 'FB50 1956 83C7 E44D 13FE 0AAA 4850 DFB1 26F1 E21C';
  String get pgpAlgorithm => 'RSA4096';
  String get pgpHref => 'https://github.com/damian-molinski.gpg';
  String get pgpAriaLabel => 'Download Damian Moliński\'s public PGP key';
}

enum IdentityNode {
  github(
    icon: AppIcon.code,
    trailing: AppIcon.northEast,
    name: 'GitHub',
    handle: '@damian-molinski',
    href: 'https://github.com/damian-molinski',
    ariaLabel: 'Damian Moliński on GitHub (@damian-molinski)',
  ),
  linkedin(
    icon: AppIcon.terminal,
    trailing: AppIcon.northEast,
    name: 'LinkedIn',
    handle: 'in/damian-moliński',
    href: 'https://www.linkedin.com/in/damian-moliński-54624713a',
    ariaLabel: 'Damian Moliński on LinkedIn (in/damian-moliński)',
  ),
  x(
    icon: AppIcon.tag,
    trailing: AppIcon.northEast,
    name: 'X',
    handle: '@DamianMoliski12',
    href: 'https://x.com/DamianMoliski12',
    ariaLabel: 'Damian Moliński on X (@DamianMoliski12)',
  ),
  ssh(
    icon: AppIcon.key,
    trailing: AppIcon.northEast,
    name: 'SSH SIGNING',
    handle: 'Trust & Verify',
    href: 'https://github.com/damian-molinski.keys',
    ariaLabel: 'Verify Damian Moliński\'s signed work on GitHub',
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
  final AppIcon trailing;
  final String name;
  final String handle;
  final String href;
  final String ariaLabel;
}

abstract interface class SpecEntry {
  int get index;
  AppIcon get icon;
  String get indexLabel;
  String get title;
  String get body;
  List<String> get tags;
}

/// Section `01` — the four competency cards.
enum Pillar implements SpecEntry {
  first(
    icon: AppIcon.database,
    indexLabel: '01/04',
    title: 'SQLite & NoSQL',
    body: 'Modelling databases and the complex queries that read them.',
    tags: ['SQLite', 'NoSQL', 'PostgreSQL'],
  ),
  second(
    icon: AppIcon.memory,
    indexLabel: '02/04',
    title: 'Dart Native & Rust FFI',
    body: 'Tapping into low-level code for mission-critical functionality, for the best performance and accuracy.',
    tags: ['dart:ffi', 'Rust', 'C++'],
  ),
  third(
    icon: AppIcon.speed,
    indexLabel: '03/04',
    title: 'Runtime Profiling',
    body: 'Deep tracing via DevTools CPU samplers for decentralized data source frontend, memory leak elimination.',
    tags: ['Frame Timings', 'Memory Heap', 'Benchmarking Performance'],
  ),
  fourth(
    icon: AppIcon.autoAwesome,
    indexLabel: '04/04',
    title: 'Mentorship & AI Software Engineering',
    body:
        'Choosing frontend architecture for the project\'s needs, writing custom analytics lints, and mentoring '
        'team members while protecting code quality with rules enforced automatically.',
    tags: ['Melos', 'Code Review', 'AI'],
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
    title: 'Full Stack Flutter Engineer',
    body: 'From one codebase to android, iOS, web & backend',
    tags: ['Jaspr', 'WASM', 'Android', 'iOS', 'Backend'],
  ),
  second(
    icon: AppIcon.palette,
    indexLabel: 'STK/02',
    title: 'Pixel Perfect UI & Animations',
    body: 'Optimizing rebuilds for best performance and smooth UI on every platform and form factor.',
    tags: ['Impeller', 'Flutter Trees', 'Bloc', 'Custom RenderObjects'],
  ),
  third(
    icon: AppIcon.monitoring,
    indexLabel: 'STK/03',
    title: 'Diagnostics & Profiling',
    body: 'Zero-overhead telemetry, memory allocation tracking, and benchmarking performance',
    tags: ['DevTools CPU Profiling', 'Memory Heap & Leak Analysis', 'Benchmarks'],
  ),
  fourth(
    icon: AppIcon.neurology,
    indexLabel: 'STK/04',
    title: 'AI-assisted Software Engineering, Tooling & Scale',
    body: 'Using AI while keeping ownership and understanding of the system.',
    tags: ['LLM', 'Agents', 'Skills', 'Melos Monorepos', 'CI/CD', 'Analytics'],
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
enum Project {
  first(
    category: '01 // Web3 & Decentralization',
    title: 'Catalyst Voices',
    body:
        'Next-generation, open-source portal for Project Catalyst—the world\'s largest decentralized innovation fund.',
    telemetry: '< 5s 10k+ documents synchronization · < 0.5s db queries',
    tags: ['Web3', 'Cardano', 'Rust', 'SQLite', 'Cryptography', 'Web & Mobile'],
    href: 'https://github.com/cardano-foundation/catalyst-voices',
  ),
  second(
    category: '02 // Adaptive Mobile',
    title: 'Habitive',
    body: 'Offline first mobile application with platform adaptive UI',
    telemetry: '100% offline capable · instant local queries',
    tags: ['NoSQL', 'SQLite', 'Platform Adaptive UI', 'l10n', 'Local Notifications'],
    href: 'https://habitive.app/',
  ),
  third(
    category: '03 // Fintech SDK & Mobile',
    title: 'Autenti',
    body: 'Signing and verifying documents with native Android SDK and mobile application',
    telemetry: '100% secure and verifiable signatures · Documents trust',
    tags: ['Fintech', 'eSign', 'Android', 'SDK'],
    href: 'https://autenti.com/pl/',
  );

  const Project({
    required this.category,
    required this.title,
    required this.body,
    required this.telemetry,
    required this.tags,
    this.href,
  });

  final String category;
  final String title;
  final String body;
  final String telemetry;
  final List<String> tags;
  final String? href;

  bool get isActive => false;

  String get linkAriaLabel => '${const ProjectContent().viewLabel}: $title';
}

/// Copy shared by the projects section's cards.
final class ProjectContent {
  const ProjectContent();

  String get activeLabel => 'Active';
  String get telemetryLabel => 'Telemetry & Target';
  String get viewLabel => 'View Project';
}

/// Section `04` — the three summary cards above the form.
enum ContactCard {
  directMail(
    icon: AppIcon.mail,
    label: 'Direct Mail',
    value: _contactEmail,
    href: 'mailto:$_contactEmail',
  ),
  responseSla(
    icon: AppIcon.timer,
    label: 'Response SLA',
    value: '≤ 24 hours for technical briefs',
  ),
  signedWork(
    icon: AppIcon.key,
    label: 'Signed & Verified',
    value: 'github.com/damian-molinski.keys',
    href: 'https://github.com/damian-molinski.keys',
  );

  const ContactCard({required this.icon, required this.label, required this.value, this.href});

  final AppIcon icon;
  final String label;
  final String value;
  final String? href;

  bool get isCopyable => this == directMail;

  /// Whether [href] leaves the site, and so needs a new tab and `rel="noopener noreferrer"`.
  bool get isExternal => href?.startsWith('http') ?? false;
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
    label: 'Your Name / Organization',
    placeholder: 'e.g. Jan Nowak, Acme Corp',
  ),
  email(
    id: 'contact-email',
    type: 'email',
    autocomplete: 'email',
    label: 'Email Address',
    placeholder: 'name@domain.com',
  ),
  brief(
    id: 'contact-brief',
    type: 'textarea',
    autocomplete: 'off',
    label: 'Project Brief',
    placeholder: 'Overview of scope, timeline, and current Dart/Flutter runtime stack...',
  );

  const ContactField({
    required this.id,
    required this.type,
    required this.autocomplete,
    required this.label,
    required this.placeholder,
  });

  final String id;
  final String type;
  final String autocomplete;
  final String label;
  final String placeholder;

  bool get isRequired => true;

  bool get isEmail => type == 'email';

  bool get isMultiline => type == 'textarea';
}

enum ScopeOption {
  audit('Architecture / Performance Audit'),
  greenfield('Greenfield Build-up'),
  development('Existing Project Development / Takeover'),
  other('General Technical Inquiry');

  const ScopeOption(this.label);

  final String label;

  String get value => name;

  static ScopeOption byValue(String value) => ScopeOption.values.byName(value);
}

/// The dispatch form's own chrome.
final class ContactFormContent {
  const ContactFormContent();

  String get fieldId => 'contact-form';
  String get scopeFieldId => 'contact-scope';
  String get scopeLabel => 'Engagement Scope';
  String get requiredHint => '(required)';
  String get submitLabel => '[ dispatch_message() ]';
  String get submittingLabel => 'Transmitting...';
  String get submittedLabel => '[ sent_successfully ]';

  String get validationMessage => 'Complete message form fist';
  String get failureMessage => 'Count not send a message';

  String get honeypotName => 'company';
  String get honeypotFieldId => 'contact-company';
}

/// The footer's link row.
enum FooterLink {
  about(label: 'About', href: '#'),
  focus(label: 'Focus', href: '#pillars'),
  skills(label: 'Skills', href: '#skills'),
  projects(label: 'Projects', href: '#projects'),
  contact(label: 'Contact', href: '#contact');

  const FooterLink({required this.label, required this.href});

  final String label;
  final String href;
}

/// Strings that belong to the page frame rather than to any one section.
final class ChromeContent {
  const ChromeContent();

  String get skipLink => 'Skip to main content';
  String get mainId => 'main-content';
  String get mainAnchor => '#$mainId';
  String get avatarAriaLabel => 'About Damian Moliński';
  String get avatarPlaceholder => '?';
}
