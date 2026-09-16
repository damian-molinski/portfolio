import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../theme.dart';

enum TagPillVariant {
  accent,
  neutral;

  String get className => 'tag-pill tag-pill--$name';
}

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
            border: AppBorders.hairline(Colors.transparent),
            radius: .all(.circular(AppRadius.pill)),
            cursor: .defaultCursor,
            transition: AppMotion.ease('all'),
            whiteSpace: .noWrap,
            backgroundColor: AppColors.surfaceContainer,
          ),
      css('&.tag-pill--accent').styles(color: AppColors.secondary),
      css('&.tag-pill--accent:hover').styles(
        border: AppBorders.hairline(AppColors.tertiary.alpha(0.6)),
        color: AppColors.tertiary,
      ),
      css('&.tag-pill--neutral').styles(
        border: AppBorders.hairline(AppColors.surfaceContainerHigh.alpha(0.6)),
        color: AppColors.onSurface,
      ),
      css('&.tag-pill--neutral:hover').styles(
        border: AppBorders.hairline(AppColors.tertiary),
        color: AppColors.tertiary,
        backgroundColor: AppColors.tertiaryContainer.alpha(0.3),
      ),
    ]),
  ];
}
