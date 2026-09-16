import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../domain/models/site_content.dart';
import '../../../utils/markup.dart';
import '../theme.dart';

class SectionShell extends StatelessComponent {
  const SectionShell({
    required this.siteSection,
    required this.children,
    this.hasDivider = true,
    super.key,
  });

  final SiteSection siteSection;
  final bool hasDivider;

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return section(
      classes: classNames(['section-shell', if (!hasDivider) 'section-shell--closing']),
      id: siteSection.id,
      attributes: {'aria-label': siteSection.ariaLabel},
      [
        div(classes: 'app-container', children),
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
          bottom: AppBorders.hairlineSide(AppColors.surfaceContainerHigh.alpha(0.3)),
        ),
        raw: {'scroll-margin-top': '5rem'},
      ),
      css('&.section-shell--closing').styles(border: const Border.only(bottom: BorderSide.none())),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.section-shell').styles(padding: .symmetric(vertical: AppSpacing.xxxl)),
    ]),
  ];
}
