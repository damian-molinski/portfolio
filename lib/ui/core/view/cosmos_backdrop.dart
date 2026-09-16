import 'dart:math';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../theme.dart';

const _starCount = 80;
const _starSeed = 20260916;
const _denseFrom = 48;

const _brightShare = 0.12;
const _cyanShare = 0.25;
const _maxDelayMs = 4000;

final _starfield = _generateStarfield();

class CosmosBackdrop extends StatelessComponent {
  const CosmosBackdrop({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'cosmos',
      attributes: const {'aria-hidden': 'true'},
      [
        div(classes: 'cosmos__base', []),
        div(classes: 'cosmos__nebula cosmos__nebula--apex', []),
        div(classes: 'cosmos__nebula cosmos__nebula--drift', []),
        div(classes: 'cosmos__nebula cosmos__nebula--trail', []),
        div(classes: 'cosmos__stars', [
          for (final star in _starfield) span(classes: star.classes, styles: star.geometry, []),
        ]),
        div(classes: 'cosmos__grid', []),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css.keyframes(_Twinkle.slow.keyframes, {
      '0%, 100%': const Styles(opacity: 0.25, transform: .scale(0.85)),
      '50%': const Styles(opacity: 0.95, transform: .scale(1.15)),
    }),
    css.keyframes(_Twinkle.medium.keyframes, {
      '0%, 100%': const Styles(opacity: 0.35, transform: .scale(0.9)),
      '50%': const Styles(opacity: 1, transform: .scale(1.25)),
    }),
    css.keyframes(_Twinkle.fast.keyframes, {
      '0%, 100%': const Styles(opacity: 0.2, transform: .scale(0.8)),
      '50%': const Styles(opacity: 0.85, transform: .scale(1.1)),
    }),

    css('.cosmos', [
      css('&').styles(
        position: .fixed(top: .zero, left: .zero, right: .zero),
        zIndex: const ZIndex(0),
        height: 100.vh,
        overflow: .hidden,
        pointerEvents: .none,
        raw: {'height': '100lvh'},
      ),

      css('.cosmos__base').styles(
        position: .absolute(top: .zero, left: .zero, right: .zero, bottom: .zero),
        raw: {
          'background-image':
              'linear-gradient(to bottom, ${AppColors.cosmosTop.value}, '
              '${AppColors.cosmosMid.value}, ${AppColors.cosmosBase.value})',
        },
      ),

      css('.cosmos__nebula').styles(position: .absolute()),

      css('.cosmos__nebula--apex').styles(
        position: .absolute(top: (-8).rem, left: 50.percent),
        width: 1200.px,
        height: 750.px,
        // Centred with a margin, not a translate: the reduced-motion rule nulls every transform.
        margin: .only(left: (-600).px),
        filter: .blur(110.px),
        raw: {
          'background-image':
              'radial-gradient(ellipse at center, ${AppColors.tertiary.alpha(0.09).value} 0%, '
              '${AppColors.primaryContainer.alpha(0.06).value} 40%, transparent 70%)',
        },
      ),

      css('.cosmos__nebula--drift').styles(
        position: .absolute(top: 35.percent, left: (-12).rem),
        width: 800.px,
        height: 700.px,
        filter: .blur(120.px),
        raw: {
          'background-image':
              'radial-gradient(ellipse at center, ${AppColors.primary.alpha(0.05).value} 0%, '
              '${AppColors.secondary.alpha(0.04).value} 45%, transparent 75%)',
        },
      ),

      css('.cosmos__nebula--trail').styles(
        position: .absolute(top: 65.percent, right: (-10).rem),
        width: 850.px,
        height: 750.px,
        filter: .blur(120.px),
        raw: {
          'background-image':
              'radial-gradient(ellipse at center, ${AppColors.tertiary.alpha(0.07).value} 0%, '
              '${AppColors.primaryContainer.alpha(0.05).value} 45%, transparent 75%)',
        },
      ),

      css('.cosmos__stars').styles(
        position: .absolute(top: .zero, left: .zero, right: .zero, bottom: .zero),
        opacity: 0.9,
      ),

      css('.cosmos__star').styles(
        display: .block,
        radius: .all(.circular(AppRadius.pill)),
        backgroundColor: AppColors.onSurface,
      ),
      css('.cosmos__star--cyan').styles(backgroundColor: AppColors.tertiary),
      css('.cosmos__star--bright').styles(
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: .zero,
          blur: 6.px,
          color: AppColors.onSurface.alpha(0.55),
        ),
      ),
      css('.cosmos__star--bright.cosmos__star--cyan').styles(
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: .zero,
          blur: 6.px,
          color: AppColors.tertiary.alpha(0.55),
        ),
      ),

      // The resting opacity is what a star reverts to once the reduced-motion rule cuts the
      // animation to 0.01ms with no fill mode, so it matches the keyframe's own 0% value.
      css('.${_Twinkle.slow.className}').styles(
        opacity: 0.25,
        animation: Animation(
          name: _Twinkle.slow.keyframes,
          duration: const Duration(milliseconds: 4500),
          curve: .easeInOut,
        ),
        raw: {'animation-iteration-count': 'infinite'},
      ),
      css('.${_Twinkle.medium.className}').styles(
        opacity: 0.35,
        animation: Animation(
          name: _Twinkle.medium.keyframes,
          duration: const Duration(milliseconds: 3200),
          curve: .easeInOut,
        ),
        raw: {'animation-iteration-count': 'infinite'},
      ),
      css('.${_Twinkle.fast.className}').styles(
        opacity: 0.2,
        animation: Animation(
          name: _Twinkle.fast.keyframes,
          duration: const Duration(milliseconds: 2400),
          curve: .easeInOut,
        ),
        raw: {'animation-iteration-count': 'infinite'},
      ),

      css('.cosmos__grid').styles(
        position: .absolute(top: .zero, left: .zero, right: .zero, bottom: .zero),
        opacity: 0.02,
        raw: {
          'background-image':
              'linear-gradient(to right, ${AppColors.secondary.value} 1px, transparent 1px), '
              'linear-gradient(to bottom, ${AppColors.secondary.value} 1px, transparent 1px)',
          'background-size': '56px 56px',
        },
      ),
    ]),

    css.media(AppBreakpoints.belowSm, [
      css('.cosmos .cosmos__star--dense').styles(display: .none),
    ]),
  ];
}

enum _Twinkle {
  slow('star-twinkle-1', 'twinkleSlow'),
  medium('star-twinkle-2', 'twinkleMedium'),
  fast('star-twinkle-3', 'twinkleFast');

  const _Twinkle(this.className, this.keyframes);

  final String className;
  final String keyframes;
}

class _Star {
  const _Star({
    required this.xPercent,
    required this.yPercent,
    required this.diameterPx,
    required this.twinkle,
    required this.delayMs,
    required this.isBright,
    required this.isCyan,
    required this.isDense,
  });

  final double xPercent;
  final double yPercent;
  final double diameterPx;
  final _Twinkle twinkle;
  final int delayMs;
  final bool isBright;
  final bool isCyan;
  final bool isDense;

  String get classes => [
    'cosmos__star',
    twinkle.className,
    if (isBright) 'cosmos__star--bright',
    if (isCyan) 'cosmos__star--cyan',
    if (isDense) 'cosmos__star--dense',
  ].join(' ');

  Styles get geometry => Styles(
    position: .absolute(top: yPercent.percent, left: xPercent.percent),
    width: diameterPx.px,
    height: diameterPx.px,
    raw: {'animation-delay': '${delayMs}ms'},
  );
}

List<_Star> _generateStarfield() {
  final random = Random(_starSeed);

  return List.generate(
    _starCount,
    (index) {
      final xPercent = _twoDecimals(random.nextDouble() * 100);
      final yPercent = _twoDecimals(random.nextDouble() * 100);
      final isBright = random.nextDouble() < _brightShare;
      final spread = random.nextDouble();
      final diameterPx = isBright ? _twoDecimals(1.6 + spread * 1.6) : _twoDecimals(0.6 + spread * 1.2);

      return _Star(
        xPercent: xPercent,
        yPercent: yPercent,
        diameterPx: diameterPx,
        twinkle: _Twinkle.values[random.nextInt(_Twinkle.values.length)],
        delayMs: random.nextInt(_maxDelayMs),
        isBright: isBright,
        isCyan: random.nextDouble() < _cyanShare,
        isDense: index >= _denseFrom,
      );
    },
    growable: false,
  );
}

double _twoDecimals(double value) => (value * 100).roundToDouble() / 100;
