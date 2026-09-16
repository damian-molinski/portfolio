import 'package:portfolio/data/repositories/site_content_repository.dart';
import 'package:portfolio/domain/models/site_content.dart';
import 'package:test/test.dart';

const _todoMarker = '[[TODO:';

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

    test('ships no placeholder copy', () {
      final content = repository.load();
      final copy = [
        content.identity.name,
        content.meta.description,
        content.hero.tagline,
        content.hero.body,
        content.signals.title,
        content.projectLabels.viewLabel,
        content.contactForm.submitLabel,
        content.chrome.skipLink,
        ...content.sections.expand((section) => [section.title, ?section.lead, ?section.note]),
        ...content.identityNodes.map((node) => node.handle),
        ...content.pillars.map((pillar) => pillar.body),
        ...content.skillGroups.map((group) => group.body),
        ...content.projects.expand((project) => [project.body, project.telemetry]),
        ...content.contactCards.expand((card) => [card.label, card.value]),
      ];

      expect(copy, everyElement(isNot(contains(_todoMarker))));
    });
  });
}
