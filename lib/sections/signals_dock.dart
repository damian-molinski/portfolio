import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icons.dart';
import '../components/node_link.dart';
import '../constants/theme.dart';
import '../data/site_content_repository.dart';
import '../state/site_content_builder.dart';
import '../utils/markup.dart';

class SignalsDock extends StatelessComponent {
  const SignalsDock({super.key});

  @override
  Component build(BuildContext context) {
    return SiteContentBuilder(builder: (context, content) => _section(content));
  }

  Component _section(SiteContent content) {
    return section(
      classes: 'signals-dock',
      id: 'signals',
      attributes: {'aria-label': content.signals.title},
      [
        div(classes: 'app-container', [
          div(classes: 'signals-dock__panel animate-fade-in-up delay-100', [
            div(classes: 'signals-dock__heading', [
              span(classes: 'signals-dock__title', [.text(content.signals.title)]),
              span(
                classes: 'signals-dock__separator',
                attributes: const {'aria-hidden': 'true'},
                [
                  .text('•'),
                ],
              ),
              span(classes: 'signals-dock__subtitle', [.text(content.signals.subtitle)]),
            ]),

            a(
              classes: 'signals-dock__pgp',
              href: content.signals.pgpHref,
              target: .blank,
              attributes: externalLinkAttributes(ariaLabel: content.signals.pgpAriaLabel),
              [
                AppIcon.fingerprint(classes: 'signals-dock__pgp-glyph'),
                span(classes: 'signals-dock__fingerprint', [.text(content.signals.pgpFingerprint)]),
                span(classes: 'signals-dock__algorithm', [.text(content.signals.pgpAlgorithm)]),
                AppIcon.northEast(classes: 'signals-dock__pgp-trailing'),
              ],
            ),

            div(classes: 'signals-dock__grid', [
              for (final node in content.identityNodes) NodeLink(node),
            ]),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.signals-dock', [
      css('&').styles(
        display: .block,
        position: .relative(),
        zIndex: const ZIndex(20),
        width: 100.percent,
        padding: .symmetric(vertical: AppSpacing.lg),
        margin: .only(top: (-1.5).rem),
        raw: {'scroll-margin-top': '5rem'},
      ),

      css('.signals-dock__panel').styles(
        display: .flex,
        padding: .all(AppSpacing.md),
        border: AppBorders.hairline(AppColors.tertiary.alpha(0.2)),
        radius: .all(.circular(AppRadius.xl)),
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: 12.px,
          blur: 32.px,
          color: AppColors.tertiaryContainer.alpha(0.2),
        ),
        backdropFilter: .blur(12.px),
        flexWrap: .wrap,
        alignItems: .center,
        gap: Gap(row: AppSpacing.sm, column: AppSpacing.sm),
        backgroundColor: AppColors.surfaceContainerLow.alpha(0.5),
      ),

      css('.signals-dock__heading').styles(
        display: .flex,
        flexWrap: .wrap,
        alignItems: .center,
        gap: Gap(row: AppSpacing.xxs, column: AppSpacing.xs),
        flex: const Flex(grow: 1, shrink: 1, basis: .auto),
        order: 1,
      ),
      css('.signals-dock__title')
          .combine(AppType.labelSm)
          .styles(
            color: AppColors.onSurfaceVariant,
            textTransform: .upperCase,
            letterSpacing: 0.08.em,
          ),
      css('.signals-dock__separator').styles(color: AppColors.onSurfaceVariant.alpha(0.4)),
      css(
        '.signals-dock__subtitle',
      ).combine(AppType.labelSm).styles(color: AppColors.tertiary, fontFamily: AppFonts.mono),

      // The design draws the PGP chip twice and hides one; this is one element reordered, so a
      // screen reader hears the fingerprint once. Below 640px it takes its own row under the grid.
      css('.signals-dock__pgp').styles(
        display: .flex,
        width: 100.percent,
        padding: .symmetric(vertical: 2.px, horizontal: AppSpacing.sm),
        border: AppBorders.hairline(AppColors.tertiary.alpha(0.2)),
        radius: .all(.circular(AppRadius.lg)),
        transition: AppMotion.ease('border-color'),
        justifyContent: .spaceBetween,
        alignItems: .center,
        gap: Gap(column: AppSpacing.xs),
        order: 3,
        backgroundColor: AppColors.surfaceContainerLow.alpha(0.8),
      ),
      css('.signals-dock__pgp:hover').styles(
        border: AppBorders.hairline(AppColors.tertiary.alpha(0.5)),
      ),
      css('.signals-dock__pgp-glyph').styles(color: AppColors.onSurfaceVariant, fontSize: 13.px),
      css('.signals-dock__fingerprint')
          .combine(AppType.labelSm)
          .styles(
            overflow: .hidden,
            flex: const Flex(grow: 1, shrink: 1, basis: .auto),
            color: AppColors.onSurface,
            fontFamily: AppFonts.mono,
            textOverflow: .ellipsis,
            whiteSpace: .noWrap,
          ),
      css('.signals-dock__algorithm')
          .combine(AppType.labelSm)
          .styles(
            color: AppColors.tertiary,
            fontWeight: .w700,
            whiteSpace: .noWrap,
          ),
      css('.signals-dock__pgp-trailing').styles(
        transition: AppMotion.ease('all'),
        color: AppColors.outline,
        fontSize: 13.px,
      ),
      css('.signals-dock__pgp:hover .signals-dock__pgp-trailing').styles(
        transform: .translate(x: 2.px, y: (-2).px),
        color: AppColors.tertiary,
      ),

      css('.signals-dock__grid').styles(
        display: .grid,
        width: 100.percent,
        gridTemplate: AppGrid.singleColumn,
        gap: Gap(row: AppSpacing.xs, column: AppSpacing.xs),
        order: 2,
      ),
    ]),

    css.media(AppBreakpoints.fromSm, [
      css('.signals-dock .signals-dock__pgp').styles(
        width: .auto,
        radius: .all(.circular(AppRadius.pill)),
        order: 1,
      ),
      css('.signals-dock .signals-dock__grid').styles(
        gridTemplate: AppGrid.twoColumns,
        order: 2,
      ),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.signals-dock .signals-dock__panel').styles(padding: .all(AppSpacing.lg)),
      css('.signals-dock .signals-dock__grid').styles(
        gridTemplate: AppGrid.fourColumns,
      ),
    ]),
  ];
}
