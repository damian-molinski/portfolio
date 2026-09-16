import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../content/site_content.dart';
import '../utils/markup.dart';

/// One tile in the identity dock: a leading glyph, the service and handle stacked beside it, and an
/// outbound arrow in the corner. Every node leaves the site, so every tile carries the same arrow.
///
/// Opens in a new tab with `rel="noopener noreferrer"`, and takes its accessible name from the node
/// rather than from the visible text, which reads as "GitHub @handle" out of context.
class NodeLink extends StatelessComponent {
  const NodeLink(this.node, {super.key});

  final IdentityNode node;

  @override
  Component build(BuildContext context) {
    return a(
      classes: 'node-link',
      href: node.href,
      target: .blank,
      attributes: externalLinkAttributes(ariaLabel: node.ariaLabel),
      [
        div(classes: 'node-link__identity', [
          node.icon(classes: 'node-link__glyph'),
          div(classes: 'node-link__text', [
            span(classes: 'node-link__name', [.text(node.name)]),
            span(classes: 'node-link__handle', [.text(node.handle)]),
          ]),
        ]),
        node.trailing(classes: 'node-link__trailing'),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.node-link', [
      css('&').styles(
        display: .flex,
        padding: .all(AppSpacing.sm),
        border: AppBorders.hairline(AppColors.surfaceContainerHigh.alpha(0.6)),
        radius: .all(.circular(AppRadius.lg)),
        transition: AppMotion.ease('all', duration: AppMotion.slow),
        justifyContent: .spaceBetween,
        alignItems: .center,
        backgroundColor: AppColors.surfaceContainerLow.alpha(0.7),
      ),
      css('&:hover').styles(
        border: AppBorders.hairline(AppColors.tertiary.alpha(0.6)),
        shadow: BoxShadow(offsetX: .zero, offsetY: 8.px, blur: 20.px, color: AppColors.tertiary.alpha(0.18)),
        transform: .translate(y: (-4).px),
        backgroundColor: AppColors.tertiaryContainer.alpha(0.2),
      ),
      css('&:active').styles(transform: .scale(0.99)),

      css('.node-link__identity').styles(
        display: .flex,
        alignItems: .center,
        gap: Gap(column: AppSpacing.xs),
      ),
      css('.node-link__text').styles(display: .flex, flexDirection: .column),

      css('.node-link__glyph').styles(
        transition: AppMotion.ease('color'),
        color: AppColors.primary,
        fontSize: 20.px,
      ),
      css('&:hover .node-link__glyph').styles(color: AppColors.tertiary),

      css('.node-link__name')
          .combine(AppType.labelMd)
          .styles(
            transition: AppMotion.ease('color'),
            color: AppColors.onSurface,
          ),
      css('&:hover .node-link__name').styles(color: AppColors.tertiaryFixed),

      css('.node-link__handle').combine(AppType.labelSm).styles(color: AppColors.onSurfaceVariant),

      css('.node-link__trailing').styles(
        transition: AppMotion.ease('all'),
        color: AppColors.outline,
        fontSize: 13.px,
      ),
      css('&:hover .node-link__trailing').styles(
        transform: .translate(x: 2.px, y: (-2).px),
        color: AppColors.tertiary,
      ),
    ]),
  ];
}
