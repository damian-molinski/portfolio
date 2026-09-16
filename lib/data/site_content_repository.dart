import 'package:equatable/equatable.dart';

import '../content/site_content.dart';

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

abstract interface class SiteContentRepository {
  /// The whole of the site's content. Synchronous, and returns no failure: there is no I/O behind it.
  SiteContent load();
}

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
