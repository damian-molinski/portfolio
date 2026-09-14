import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../data/site_content_repository.dart';
import '../state/bloc_builder.dart';
import '../state/site_content_cubit.dart';
import '../state/site_content_state.dart';

/// The page footer.
///
/// Its link row is also the only route between sections below 768px, where A2 hides the header nav,
/// so it is a `<nav>` rather than a plain row of anchors.
class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return BlocBuilder<SiteContentCubit, SiteContentState>(
      builder: (context, state) => _footer(state.content),
    );
  }

  Component _footer(SiteContent content) {
    return footer(classes: 'site-footer', [
      div(classes: 'site-footer__bar', [
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
          top: BorderSide.solid(color: AppColors.surfaceContainerHigh.alpha(0.4), width: 1.px),
        ),
        backgroundColor: AppColors.surfaceContainerLowest,
      ),

      css('.site-footer__bar').styles(
        display: .flex,
        maxWidth: AppSpacing.containerMax,
        padding: .symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.gutterMobile),
        margin: .symmetric(horizontal: Unit.auto),
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
            transition: Transition('color', duration: 200.ms, curve: .easeOut),
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

    // From 768px the links and the copyright share a row.
    css.media(AppBreakpoints.fromMd, [
      css('.site-footer .site-footer__bar').styles(flexDirection: .row),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.site-footer .site-footer__bar').styles(
        padding: .symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.gutterDesktop),
      ),
    ]),
  ];
}
