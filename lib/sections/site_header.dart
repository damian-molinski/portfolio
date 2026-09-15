import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../data/site_content_repository.dart';
import '../state/bloc_builder.dart';
import '../state/site_content_cubit.dart';
import '../state/site_content_state.dart';

/// The fixed page header.
///
/// Sits above everything at `z-index: 50` on a translucent `surface` ground that blurs whatever
/// scrolls beneath it. The nav disappears below 768px with nothing replacing it: assumption A2
/// mirrors the design, which has no mobile menu, rather than inventing one here.
class SiteHeader extends StatelessComponent {
  const SiteHeader({super.key});

  @override
  Component build(BuildContext context) {
    return BlocBuilder<SiteContentCubit, SiteContentState>(
      builder: (context, state) => _header(state.content),
    );
  }

  Component _header(SiteContent content) {
    return header(classes: 'site-header', [
      div(classes: 'site-header__bar', [
        div(classes: 'site-header__brand', [
          img(
            alt: content.identity.emblemAlt,
            src: content.identity.emblem,
            classes: 'site-header__emblem',
          ),
          div(classes: 'site-header__wordmark', [
            span(classes: 'site-header__name', [.text(content.identity.name)]),
            span(classes: 'site-header__role', [.text(content.identity.role)]),
          ]),
        ]),

        nav(classes: 'site-header__nav', [
          for (final section in content.sections)
            a(classes: 'site-header__link', href: section.anchor, [.text(section.navLabel)]),
        ]),
        div(
          classes: 'site-header__avatar',
          attributes: {'role': 'img', 'aria-label': content.chrome.avatarAriaLabel},
          [
            .text(content.chrome.avatarPlaceholder),
          ],
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-header', [
      css('&').styles(
        position: .fixed(top: .zero, left: .zero, right: .zero),
        zIndex: const ZIndex(50),
        border: Border.only(
          bottom: BorderSide.solid(color: AppColors.surfaceContainerHigh.alpha(0.4), width: 1.px),
        ),
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: 1.px,
          blur: 16.px,
          color: const Color.rgba(0, 0, 0, 0.5),
        ),
        backdropFilter: .blur(20.px),
        backgroundColor: AppColors.surface.alpha(0.8),
      ),

      css('.site-header__bar').styles(
        display: .flex,
        height: 4.rem,
        maxWidth: AppSpacing.containerMax,
        padding: .symmetric(horizontal: AppSpacing.gutterMobile),
        margin: .symmetric(horizontal: Unit.auto),
        alignItems: .center,
        gap: Gap(column: AppSpacing.md),
      ),

      css('.site-header__brand').styles(
        display: .flex,
        minWidth: .zero,
        margin: .only(right: Unit.auto),
        alignItems: .center,
        gap: Gap(column: AppSpacing.sm),
      ),
      css('.site-header__emblem').styles(
        width: .auto,
        height: 32.px,
        transition: Transition('transform', duration: 200.ms, curve: .easeOut),
        flex: const Flex(grow: 0, shrink: 0, basis: .auto),
        raw: {'object-fit': 'contain'},
      ),
      css('.site-header__brand:hover .site-header__emblem').styles(transform: .scale(1.05)),

      css('.site-header__wordmark').styles(
        display: .flex,
        minWidth: .zero,
        overflow: .hidden,
        flexDirection: .column,
      ),
      css('.site-header__name')
          .combine(AppType.headlineSm)
          .styles(
            overflow: .hidden,
            color: AppColors.onSurface,
            lineHeight: 1.2.em,
            textOverflow: .ellipsis,
            whiteSpace: .noWrap,
          ),
      css('.site-header__role')
          .combine(AppType.labelSm)
          .styles(
            overflow: .hidden,
            color: AppColors.onSurfaceVariant,
            textOverflow: .ellipsis,
            whiteSpace: .noWrap,
          ),

      css('.site-header__nav').styles(display: .none),
      css('.site-header__link')
          .combine(AppType.labelMd)
          .styles(
            padding: .symmetric(horizontal: AppSpacing.xxs),
            radius: .all(.circular(AppRadius.base)),
            transition: Transition('all', duration: 200.ms, curve: .easeOut),
            color: AppColors.onSurfaceVariant,
            whiteSpace: .noWrap,
          ),
      css('.site-header__link:hover').styles(
        transform: .translate(y: (-1).px),
        color: AppColors.tertiary,
      ),

      css('.site-header__avatar')
          .combine(AppType.labelMd)
          .styles(
            display: .inlineFlex,
            width: 32.px,
            height: 32.px,
            border: Border.all(
              style: .dashed,
              color: AppColors.tertiary.alpha(0.4),
              width: 1.px,
            ),
            radius: .all(.circular(AppRadius.pill)),
            shadow: BoxShadow(
              offsetX: .zero,
              offsetY: .zero,
              blur: 10.px,
              color: AppColors.tertiary.alpha(0.2),
            ),
            transition: Transition('all', duration: 300.ms, curve: .easeOut),
            justifyContent: .center,
            alignItems: .center,
            flex: const Flex(grow: 0, shrink: 0, basis: .auto),
            color: AppColors.tertiary,
            backgroundColor: AppColors.surfaceContainerHigh,
          ),
      css('.site-header__avatar:hover').styles(
        border: Border.all(style: .solid, color: AppColors.tertiary, width: 1.px),
        transform: .scale(1.05),
      ),
    ]),

    css.media(AppBreakpoints.fromMd, [
      css('.site-header .site-header__nav').styles(
        display: .flex,
        alignItems: .center,
        gap: Gap(column: AppSpacing.md),
      ),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.site-header .site-header__bar').styles(
        padding: .symmetric(horizontal: AppSpacing.gutterDesktop),
      ),
    ]),
  ];
}
