import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../data/site_content_repository.dart';
import '../state/site_content_builder.dart';

class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return SiteContentBuilder(builder: (context, content) => _footer(content));
  }

  Component _footer(SiteContent content) {
    return footer(classes: 'site-footer', [
      div(classes: 'site-footer__bar app-container', [
        nav(classes: 'site-footer__links', [
          for (final link in content.footerLinks) a(classes: 'site-footer__link', href: link.href, [.text(link.label)]),
        ]),
        span(classes: 'site-footer__copyright', [.text(content.identity.copyright)]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      css('&').styles(
        width: 100.percent,
        border: Border.only(
          top: AppBorders.hairlineSide(AppColors.surfaceContainerHigh.alpha(0.4)),
        ),
        backgroundColor: AppColors.surfaceContainerLowest,
      ),

      css('.site-footer__bar').styles(
        display: .flex,
        // Vertical only — `.app-container` owns the horizontal gutter as longhands.
        padding: .symmetric(vertical: AppSpacing.xl),
        flexDirection: .column,
        justifyContent: .spaceBetween,
        alignItems: .center,
        gap: Gap(row: AppSpacing.md, column: AppSpacing.md),
      ),

      css('.site-footer__links').styles(
        display: .flex,
        flexWrap: .wrap,
        justifyContent: .center,
        alignItems: .center,
        gap: Gap(row: AppSpacing.xs, column: AppSpacing.md),
      ),
      css('.site-footer__link')
          .combine(AppType.labelMd)
          .styles(
            padding: .symmetric(horizontal: AppSpacing.xxs),
            radius: .all(.circular(AppRadius.base)),
            transition: AppMotion.ease('color'),
            color: AppColors.onSurfaceVariant,
            whiteSpace: .noWrap,
          ),
      css('.site-footer__link:hover').styles(color: AppColors.tertiary),

      css('.site-footer__copyright')
          .combine(AppType.labelSm)
          .styles(
            color: AppColors.onSurfaceVariant.alpha(0.7),
            textAlign: .center,
          ),
    ]),

    css.media(AppBreakpoints.fromMd, [
      css('.site-footer .site-footer__bar').styles(flexDirection: .row),
    ]),
  ];
}
