import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../content/site_content.dart';

/// The `<section>` wrapper the four numbered sections share.
///
/// It carries the landmark and its accessible name, the vertical rhythm, the hairline that separates
/// one section from the next, and the container that holds everything to `72rem` on the page gutter.
/// Sections supply only what goes inside.
class SectionShell extends StatelessComponent {
  const SectionShell({
    required this.siteSection,
    required this.children,
    this.hasDivider = true,
    super.key,
  });

  final SiteSection siteSection;

  /// Whether a hairline closes the section. The last one on the page hands off to the footer instead.
  final bool hasDivider;

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    final className = hasDivider ? 'section-shell' : 'section-shell section-shell--closing';

    return section(
      classes: className,
      id: siteSection.id,
      attributes: {'aria-label': siteSection.ariaLabel},
      [
        div(classes: 'section-shell__container', children),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.section-shell', [
      css('&').styles(
        display: .block,
        position: .relative(),
        width: 100.percent,
        padding: .symmetric(vertical: AppSpacing.xxl),
        border: Border.only(
          bottom: BorderSide.solid(color: AppColors.surfaceContainerHigh.alpha(0.3), width: 1.px),
        ),
        // The header is fixed and out of flow, so an anchor jump would otherwise land the section's
        // first line underneath it. Its 4rem, plus a little air.
        raw: {'scroll-margin-top': '5rem'},
      ),
      css('&.section-shell--closing').styles(border: const Border.only(bottom: BorderSide.none())),

      css('.section-shell__container').styles(
        maxWidth: AppSpacing.containerMax,
        padding: .symmetric(horizontal: AppSpacing.gutterMobile),
        margin: .symmetric(horizontal: Unit.auto),
      ),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.section-shell').styles(padding: .symmetric(vertical: AppSpacing.xxxl)),
      css('.section-shell .section-shell__container').styles(
        padding: .symmetric(horizontal: AppSpacing.gutterDesktop),
      ),
    ]),
  ];
}
