import '../../domain/models/site_content.dart';

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
