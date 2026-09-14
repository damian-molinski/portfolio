import 'package:portfolio/content/site_content.dart';
import 'package:portfolio/data/site_content_repository.dart';
import 'package:test/test.dart';

void main() {
  group(ConstSiteContentRepository, () {
    const repository = ConstSiteContentRepository();

    test('carries every enum in full', () {
      final content = repository.load();

      expect(content.sections, SiteSection.values);
      expect(content.identityNodes, IdentityNode.values);
      expect(content.pillars, Pillar.values);
      expect(content.skillGroups, SkillGroup.values);
      expect(content.projects, Project.values);
      expect(content.contactCards, ContactCard.values);
      expect(content.contactFields, ContactField.values);
      expect(content.scopeOptions, ScopeOption.values);
      expect(content.footerLinks, FooterLink.values);
    });

    test('reads the holders rather than restating them', () {
      final content = repository.load();

      expect(content.identity.email, const SiteIdentity().email);
      expect(content.hero.copyCta, const HeroContent().copyCta);
      expect(content.chrome.mainAnchor, '#${const ChromeContent().mainId}');
    });

    test('is deterministic, which is what lets the islands resolve it independently', () {
      expect(repository.load(), repository.load());
    });

    test('still ships nothing but markers', () {
      final content = repository.load();
      final copy = [
        content.identity.name,
        content.hero.tagline,
        content.signals.title,
        content.projectLabels.viewLabel,
        content.contactForm.submitLabel,
        content.chrome.skipLink,
      ];

      expect(copy, everyElement(startsWith(todoMarker)));
    });
  });
}
