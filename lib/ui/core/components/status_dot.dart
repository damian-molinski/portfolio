import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../theme.dart';

class StatusDot extends StatelessComponent {
  const StatusDot({super.key});

  @override
  Component build(BuildContext context) {
    return span(
      classes: 'status-dot',
      attributes: const {'aria-hidden': 'true'},
      [
        span(classes: 'status-dot__ring', []),
        span(classes: 'status-dot__core', []),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css.keyframes('statusRing', {
      '75%, 100%': Styles(opacity: 0, transform: .scale(2)),
    }),

    css('.status-dot', [
      css('&').styles(
        display: .inlineFlex,
        position: .relative(),
        width: 8.px,
        height: 8.px,
        flex: const Flex(grow: 0, shrink: 0, basis: .auto),
      ),

      css('.status-dot__ring').styles(
        display: .inlineFlex,
        position: .absolute(),
        width: 100.percent,
        height: 100.percent,
        radius: .all(.circular(AppRadius.pill)),
        opacity: 0.75,
        animation: const Animation(
          name: 'statusRing',
          duration: Duration(seconds: 1),
          curve: .cubicBezier(0, 0, 0.2, 1),
        ),
        backgroundColor: AppColors.tertiary,
        raw: {'animation-iteration-count': 'infinite'},
      ),

      css('.status-dot__core').styles(
        display: .inlineFlex,
        position: .relative(),
        width: 100.percent,
        height: 100.percent,
        radius: .all(.circular(AppRadius.pill)),
        shadow: BoxShadow(offsetX: .zero, offsetY: .zero, blur: 8.px, color: AppColors.tertiary),
        backgroundColor: AppColors.tertiary,
      ),
    ]),
  ];
}
