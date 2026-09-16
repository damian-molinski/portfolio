import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../../domain/models/site_content.dart';
import '../../../core/components/section_heading.dart';
import '../../../core/components/section_shell.dart';
import '../../../core/components/spec_entry_card.dart';
import '../../../core/components/tag_pill.dart';
import '../../../core/view_model/site_content_builder.dart';

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
