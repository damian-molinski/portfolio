import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../domain/models/site_content.dart';
import '../theme.dart';

class SectionShell extends StatelessComponent {
  const SectionShell({
    required this.siteSection,
    required this.children,
    super.key,
  });

  final SiteSection siteSection;

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return section(
      classes: 'section-shell',
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
        raw: {'scroll-margin-top': '5rem'},
      ),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.section-shell').styles(padding: .symmetric(vertical: AppSpacing.xxxl)),
    ]),
  ];
}
