import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../utils/markup.dart';

/// The card shell shared by the pillars, skills and projects grids.
///
/// It owns the whole treatment — the frosted fill, the hairline that brightens across the top edge on
/// hover, the lift and the cyan glow — so a section supplies only its contents. Sections that need to
/// react to the card's hover state key off `.spec-card:hover` from their own rules rather than
/// passing styling in.
///
/// The top hairline is a `::before` rather than a child element: it is decoration, and it has no
/// business in the accessibility tree.
class SpecCard extends StatelessComponent {
  const SpecCard({required this.children, this.minHeight, this.classes, super.key});

  final List<Component> children;

  /// Defaults to the 300px the pillars and skills grids use. The projects grid passes 360px.
  final Unit? minHeight;

  /// An extra class for the section to hang its own rules on.
  final String? classes;

  @override
  Component build(BuildContext context) {
    return div(
      classes: classNames(['spec-card', classes]),
      styles: minHeight == null ? null : Styles(minHeight: minHeight),
      children,
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.spec-card', [
      css('&').styles(
        display: .flex,
        position: .relative(),
        minHeight: 300.px,
        padding: .all(AppSpacing.lg),
        border: AppBorders.hairline(AppColors.surfaceContainerHigh.alpha(0.4)),
        radius: .all(.circular(AppRadius.xl)),
        overflow: .hidden,
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: 4.px,
          blur: 6.px,
          color: const Color.rgba(0, 0, 0, 0.18),
        ),
        transition: AppMotion.ease('all', duration: AppMotion.slow),
        flexDirection: .column,
        justifyContent: .spaceBetween,
        backgroundColor: AppColors.surfaceContainerLow.alpha(0.8),
      ),
      css('&::before').styles(
        content: '',
        position: .absolute(top: .zero, left: .zero, right: .zero),
        height: 2.px,
        opacity: 0.4,
        transition: AppMotion.ease('opacity', duration: AppMotion.slow),
        raw: {
          'background-image': 'linear-gradient(to right, transparent, ${AppColors.tertiary.value}, transparent)',
        },
      ),
      css('&:hover').styles(
        border: AppBorders.hairline(AppColors.tertiary.alpha(0.5)),
        shadow: BoxShadow(offsetX: .zero, offsetY: 16.px, blur: 36.px, color: AppColors.tertiary.alpha(0.12)),
        transform: .translate(y: (-6).px),
        backgroundColor: AppColors.surfaceContainer,
      ),
      css('&:hover::before').styles(opacity: 1),
    ]),
  ];
}
