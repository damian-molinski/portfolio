import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../data/site_content_repository.dart';
import '../state/site_content_builder.dart';

class SiteHeader extends StatelessComponent {
  const SiteHeader({super.key});

  @override
  Component build(BuildContext context) {
    return SiteContentBuilder(builder: (context, content) => _header(content));
  }

  Component _header(SiteContent content) {
    return header(classes: 'site-header', [
      div(classes: 'site-header__bar app-container', [
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
        img(
          alt: content.identity.portraitAlt,
          src: content.identity.portrait,
          classes: 'site-header__avatar',
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
          bottom: AppBorders.hairlineSide(AppColors.surfaceContainerHigh.alpha(0.4)),
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
        transition: AppMotion.ease('transform'),
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
            transition: AppMotion.ease('all'),
            color: AppColors.onSurfaceVariant,
            whiteSpace: .noWrap,
          ),
      css('.site-header__link:hover').styles(
        transform: .translate(y: (-1).px),
        color: AppColors.tertiary,
      ),

      css('.site-header__avatar').styles(
        display: .block,
        width: 32.px,
        height: 32.px,
        border: Border.all(
          style: .dashed,
          color: AppColors.tertiary.alpha(0.4),
          width: 1.px,
        ),
        radius: .all(.circular(AppRadius.pill)),
        overflow: .hidden,
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: .zero,
          blur: 10.px,
          color: AppColors.tertiary.alpha(0.2),
        ),
        transition: AppMotion.ease('all', duration: AppMotion.slow),
        flex: const Flex(grow: 0, shrink: 0, basis: .auto),
        raw: {'object-fit': 'cover'},
      ),
      css('.site-header__avatar:hover').styles(
        border: AppBorders.hairline(AppColors.tertiary),
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
  ];
}
