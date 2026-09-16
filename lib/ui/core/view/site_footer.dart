import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../binding/bloc_builder.dart';
import '../theme.dart';
import '../view_model/app_shell_state.dart';
import '../view_model/app_shell_view_model.dart';

class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return BlocBuilder<AppShellViewModel, AppShellState>(
      builder: (context, state) => _footer(state),
    );
  }

  Component _footer(AppShellState state) {
    return footer(classes: 'site-footer', [
      div(classes: 'site-footer__bar app-container', [
        nav(classes: 'site-footer__links', [
          for (final link in state.footerLinks)
            a(
              classes: 'site-footer__link',
              href: link.href,
              [.text(link.label)],
            ),
        ]),
        span(classes: 'site-footer__copyright', [.text(state.identity.copyright)]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      // Positioned on purpose: the backdrop is fixed at `z-index: 0`, which paints over the
      // background of any static in-flow sibling.
      css('&').styles(
        position: .relative(),
        zIndex: const ZIndex(1),
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
