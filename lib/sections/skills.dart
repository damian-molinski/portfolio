import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/section_heading.dart';
import '../components/section_shell.dart';
import '../components/spec_entry_card.dart';
import '../components/tag_pill.dart';
import '../content/site_content.dart';
import '../data/site_content_repository.dart';
import '../state/site_content_builder.dart';

/// Section `02` — the four capability groups.
///
/// The same card as [Pillars], with five tags apiece; the bordered pill variant is what keeps five of
/// them legible as a group rather than a smear.
class Skills extends StatelessComponent {
  const Skills({super.key});

  @override
  Component build(BuildContext context) {
    return SiteContentBuilder(builder: (context, content) => _section(content));
  }

  Component _section(SiteContent content) {
    return SectionShell(
      siteSection: SiteSection.skills,
      children: [
        SectionHeading.forSection(SiteSection.skills),
        div(classes: 'spec-entry-grid', [
          for (final group in content.skillGroups)
            SpecEntryCard(
              group,
              tagVariant: TagPillVariant.neutral,
            ),
        ]),
      ],
    );
  }
}
