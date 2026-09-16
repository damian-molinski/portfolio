import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/server_test.dart';
import 'package:portfolio/components/section_shell.dart';
import 'package:portfolio/components/spec_entry_card.dart';
import 'package:portfolio/components/tag_pill.dart';
import 'package:portfolio/constants/theme.dart';
import 'package:portfolio/content/site_content.dart';

import 'render.dart';

/// The two shells every section is built out of, rendered on their own.
///
/// Neither reads a cubit, so these need no container — they take what they render as arguments.
void main() {
  group(SectionShell, () {
    testServer('emits a named landmark on the page container', (tester) async {
      const siteSection = SiteSection.pillars;

      final rendered = await tester.render(
        const SectionShell(siteSection: siteSection, children: []),
      );
      final landmark = rendered.querySelector('section')!;

      expect(landmark.id, siteSection.id);
      expect(landmark.attributes, containsPair('aria-label', siteSection.ariaLabel));
      // The page's one horizontal measure, shared with the header, hero, dock and footer.
      expect(rendered.querySelector('section > div')!.classes, contains('app-container'));
    });

    testServer('closes the page rather than ruling off, when told to', (tester) async {
      final divided = await tester.render(
        const SectionShell(siteSection: SiteSection.projects, children: []),
      );
      final closing = await tester.render(
        const SectionShell(siteSection: SiteSection.contact, hasDivider: false, children: []),
      );

      expect(divided.querySelector('section')!.classes, isNot(contains('section-shell--closing')));
      expect(closing.querySelector('section')!.classes, contains('section-shell--closing'));
    });
  });

  group(SpecEntryCard, () {
    Component cardFor(SpecEntry entry, {TagPillVariant variant = TagPillVariant.accent}) {
      return SpecEntryCard(entry, tagVariant: variant);
    }

    testServer('renders the entry and every tag on it', (tester) async {
      const entry = Pillar.first;

      final rendered = await tester.render(cardFor(entry));
      final tags = rendered.querySelectorAll('.tag-pill').map((pill) => pill.text);

      expect(rendered.querySelector('.spec-entry__title')!.text, entry.title);
      expect(rendered.querySelector('.spec-entry__body')!.text, entry.body);
      expect(rendered.querySelector('.spec-entry__index')!.text, entry.indexLabel);
      expect(tags, orderedEquals(entry.tags));
    });

    testServer('takes its accent from where the card sits, not from what it says', (tester) async {
      for (final entry in Pillar.values) {
        final expected = AppAccent.atPosition(entry.index);

        final rendered = await tester.render(cardFor(entry));

        expect(
          rendered.querySelector('.spec-entry__tile')!.classes,
          contains('spec-entry__tile--${expected.name}'),
        );
      }
    });

    testServer('draws the skills variant with edges, so five pills stay a group', (tester) async {
      final rendered = await tester.render(
        cardFor(SkillGroup.first, variant: TagPillVariant.neutral),
      );

      expect(rendered.querySelectorAll('.tag-pill--neutral'), hasLength(SkillGroup.first.tags.length));
      expect(rendered.querySelectorAll('.tag-pill--accent'), isEmpty);
    });
  });
}
