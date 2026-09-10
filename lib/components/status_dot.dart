import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

/// The two live-indicator treatments in the design.
enum StatusDotTone {
  /// A solid dot with a second ring expanding out of it. The hero's availability pill.
  beacon,

  /// A smaller dot fading in and out. The projects grid's "Active" markers, where three of them
  /// firing rings at once would be noise.
  pulse;

  String get className => switch (this) {
    beacon => 'status-dot status-dot--beacon',
    pulse => 'status-dot status-dot--pulse',
  };
}

/// A live-status indicator.
///
/// Decorative — whatever it is signalling is said in the text beside it, so it stays out of the
/// accessibility tree. Both animations stop under `prefers-reduced-motion`, which leaves the dot
/// visible and simply still.
class StatusDot extends StatelessComponent {
  const StatusDot({this.tone = StatusDotTone.beacon, super.key});

  final StatusDotTone tone;

  @override
  Component build(BuildContext context) {
    return span(
      classes: tone.className,
      attributes: const {'aria-hidden': 'true'},
      [
        if (tone == StatusDotTone.beacon) span(classes: 'status-dot__ring', []),
        span(classes: 'status-dot__core', []),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css.keyframes('statusRing', {
      '75%, 100%': Styles(opacity: 0, transform: .scale(2)),
    }),
    css.keyframes('statusPulse', {
      '0%, 100%': Styles(opacity: 1),
      '50%': Styles(opacity: 0.4),
    }),

    css('.status-dot', [
      css('&').styles(
        display: .inlineFlex,
        position: .relative(),
        flex: const Flex(grow: 0, shrink: 0, basis: .auto),
      ),
      css('&.status-dot--beacon').styles(width: 8.px, height: 8.px),
      css('&.status-dot--pulse').styles(width: 6.px, height: 6.px),

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
        backgroundColor: AppColors.tertiary,
      ),
      css('&.status-dot--beacon .status-dot__core').styles(
        shadow: BoxShadow(offsetX: .zero, offsetY: .zero, blur: 8.px, color: AppColors.tertiary),
      ),
      css('&.status-dot--pulse .status-dot__core').styles(
        animation: const Animation(name: 'statusPulse', duration: Duration(seconds: 2), curve: .easeInOut),
        raw: {'animation-iteration-count': 'infinite'},
      ),
    ]),
  ];
}
