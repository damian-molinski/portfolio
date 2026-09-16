import 'package:equatable/equatable.dart';

import '../content/site_content.dart';

/// Every string and list the page renders, as one value.
///
/// The holders in `lib/content/site_content.dart` are `const`-constructible so they can travel
/// through a bloc state; the nine enums are already values and are carried here as their `.values`
/// lists so a section never reaches for a static.
final class SiteContent extends Equatable {
  const SiteContent({
    required this.identity,
    required this.meta,
    required this.hero,
    required this.signals,
    required this.projectLabels,
    required this.contactForm,
    required this.chrome,
    required this.sections,
    required this.identityNodes,
    required this.pillars,
    required this.skillGroups,
    required this.projects,
    required this.contactCards,
    required this.scopeOptions,
    required this.footerLinks,
  });

  final SiteIdentity identity;
  final SiteMeta meta;
  final HeroContent hero;
  final SignalsContent signals;
  final ProjectContent projectLabels;
  final ContactFormContent contactForm;
  final ChromeContent chrome;
  final List<SiteSection> sections;
  final List<IdentityNode> identityNodes;
  final List<Pillar> pillars;
  final List<SkillGroup> skillGroups;
  final List<Project> projects;
  final List<ContactCard> contactCards;
  final List<ScopeOption> scopeOptions;
  final List<FooterLink> footerLinks;

  @override
  List<Object?> get props => [
    identity,
    meta,
    hero,
    signals,
    projectLabels,
    contactForm,
    chrome,
    sections,
    identityNodes,
    pillars,
    skillGroups,
    projects,
    contactCards,
    scopeOptions,
    footerLinks,
  ];
}

/// Where the page's copy comes from.
abstract interface class SiteContentRepository {
  /// The whole of the site's content.
  ///
  /// Synchronous, and returns no failure: there is no I/O behind it. Wrapping `const` data in a
  /// `Future` would buy a loading state the page can never actually be in, and this repo has
  /// already refused that once — see [ContactFormContent] and the no-op dispatch it documents.
  SiteContent load();
}

/// Reads the content straight out of `lib/content/site_content.dart`.
final class ConstSiteContentRepository implements SiteContentRepository {
  const ConstSiteContentRepository();

  @override
  SiteContent load() {
    return const SiteContent(
      identity: SiteIdentity(),
      meta: SiteMeta(),
      hero: HeroContent(),
      signals: SignalsContent(),
      projectLabels: ProjectContent(),
      contactForm: ContactFormContent(),
      chrome: ChromeContent(),
      sections: SiteSection.values,
      identityNodes: IdentityNode.values,
      pillars: Pillar.values,
      skillGroups: SkillGroup.values,
      projects: Project.values,
      contactCards: ContactCard.values,
      scopeOptions: ScopeOption.values,
      footerLinks: FooterLink.values,
    );
  }
}
