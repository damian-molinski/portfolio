import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/section_heading.dart';
import '../components/section_shell.dart';
import '../components/spec_entry_card.dart';
import '../components/tag_pill.dart';
import '../content/site_content.dart';

/// Section `01` — the four competency cards.
///
/// Everything visual lives in [SectionShell] and [SpecEntryCard]; this only says which entries go in
/// and which pill treatment they take.
class Pillars extends StatelessComponent {
  const Pillars({super.key});

  @override
  Component build(BuildContext context) {
    return SectionShell(
      siteSection: SiteSection.pillars,
      children: [
        SectionHeading.forSection(SiteSection.pillars),
        div(classes: 'spec-entry-grid', [
          for (final pillar in Pillar.values)
            SpecEntryCard(
              pillar,
              tagVariant: TagPillVariant.accent,
            ),
        ]),
      ],
    );
  }
}
