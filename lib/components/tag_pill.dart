import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

/// Which of the two pill treatments the design uses.
enum TagPillVariant {
  /// Borderless until hovered. Used on the pillars and projects cards, where the pills sit under a
  /// heading that is already doing the work of separating them.
  accent,

  /// Carries a hairline at rest and fills with cyan on hover. Used on the skills cards, where five
  /// pills per card need edges to stay legible as a group.
  neutral;

  String get className => switch (this) {
    accent => 'tag-pill tag-pill--accent',
    neutral => 'tag-pill tag-pill--neutral',
  };
}

/// A technology tag.
///
/// Not interactive — `cursor: default` and no focus behaviour, matching the design. These are labels
/// that happen to be pill-shaped, not filters.
class TagPill extends StatelessComponent {
  const TagPill(this.label, {this.variant = TagPillVariant.accent, super.key});

  final String label;
  final TagPillVariant variant;

  @override
  Component build(BuildContext context) => span(classes: variant.className, [.text(label)]);

  @css
  static List<StyleRule> get styles => [
    css('.tag-pill', [
      css('&')
          .combine(AppType.labelSm)
          .styles(
            display: .inlineBlock,
            padding: .symmetric(vertical: 2.px, horizontal: AppSpacing.xs),
            border: .all(style: .solid, color: Colors.transparent, width: 1.px),
            radius: .all(.circular(AppRadius.pill)),
            cursor: .defaultCursor,
            transition: Transition('all', duration: 200.ms, curve: .easeOut),
            whiteSpace: .noWrap,
            backgroundColor: AppColors.surfaceContainer,
          ),
      css('&.tag-pill--accent').styles(color: AppColors.secondary),
      css('&.tag-pill--accent:hover').styles(
        border: .all(style: .solid, color: AppColors.tertiary.alpha(0.6), width: 1.px),
        color: AppColors.tertiary,
      ),
      css('&.tag-pill--neutral').styles(
        border: .all(style: .solid, color: AppColors.surfaceContainerHigh.alpha(0.6), width: 1.px),
        color: AppColors.onSurface,
      ),
      css('&.tag-pill--neutral:hover').styles(
        border: .all(style: .solid, color: AppColors.tertiary, width: 1.px),
        color: AppColors.tertiary,
        backgroundColor: AppColors.tertiaryContainer.alpha(0.3),
      ),
    ]),
  ];
}
