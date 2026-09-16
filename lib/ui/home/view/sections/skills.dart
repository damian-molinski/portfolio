import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../../domain/models/site_content.dart';
import '../../../core/binding/bloc_builder.dart';
import '../../../core/components/section_heading.dart';
import '../../../core/components/section_shell.dart';
import '../../../core/components/spec_entry_card.dart';
import '../../../core/components/tag_pill.dart';
import '../../view_model/home_state.dart';
import '../../view_model/home_view_model.dart';

class Skills extends StatelessComponent {
  const Skills({super.key});

  @override
  Component build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) => _section(state),
    );
  }

  Component _section(HomeState state) {
    return SectionShell(
      siteSection: SiteSection.skills,
      children: [
        SectionHeading.forSection(SiteSection.skills),
        div(classes: 'spec-entry-grid', [
          for (final group in state.skillGroups)
            SpecEntryCard(
              group,
              tagVariant: TagPillVariant.neutral,
            ),
        ]),
      ],
    );
  }
}
