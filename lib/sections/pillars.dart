import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/section_heading.dart';
import '../components/section_shell.dart';
import '../components/spec_entry_card.dart';
import '../components/tag_pill.dart';
import '../content/site_content.dart';
import '../data/site_content_repository.dart';
import '../state/site_content_builder.dart';

class Pillars extends StatelessComponent {
  const Pillars({super.key});

  @override
  Component build(BuildContext context) {
    return SiteContentBuilder(builder: (context, content) => _section(content));
  }

  Component _section(SiteContent content) {
    return SectionShell(
      siteSection: SiteSection.pillars,
      children: [
        SectionHeading.forSection(SiteSection.pillars),
        div(classes: 'spec-entry-grid', [
          for (final pillar in content.pillars)
            SpecEntryCard(
              pillar,
              tagVariant: TagPillVariant.accent,
            ),
        ]),
      ],
    );
  }
}
