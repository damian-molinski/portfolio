import 'package:jaspr/dom.dart';

abstract final class AppColors {
  static const surface = Color('#0f131c');
  static const surfaceDim = Color('#0f131c');
  static const surfaceBright = Color('#353942');
  static const surfaceContainerLowest = Color('#0a0e16');
  static const surfaceContainerLow = Color('#181c24');
  static const surfaceContainer = Color('#1c2028');
  static const surfaceContainerHigh = Color('#262a33');
  static const surfaceContainerHighest = Color('#31353e');
  static const surfaceVariant = Color('#31353e');
  static const surfaceTint = Color('#9ecaff');
  static const background = Color('#0f131c');

  static const cosmosTop = Color('#02040a');
  static const cosmosMid = Color('#060b18');
  static const cosmosBase = Color('#030712');

  static const onSurface = Color('#dfe2ee');
  static const onSurfaceVariant = Color('#c0c7d3');
  static const onBackground = Color('#dfe2ee');
  static const inverseSurface = Color('#dfe2ee');
  static const inverseOnSurface = Color('#2c3039');

  static const outline = Color('#8a919c');
  static const outlineVariant = Color('#404751');

  static const primary = Color('#9ecaff');
  static const onPrimary = Color('#003258');
  static const primaryContainer = Color('#0175c2');
  static const onPrimaryContainer = Color('#f5f7ff');
  static const inversePrimary = Color('#0061a3');
  static const primaryFixed = Color('#d1e4ff');
  static const primaryFixedDim = Color('#9ecaff');
  static const onPrimaryFixed = Color('#001d36');
  static const onPrimaryFixedVariant = Color('#00497c');

  static const secondary = Color('#7ad0ff');
  static const onSecondary = Color('#003549');
  static const secondaryContainer = Color('#00a9e3');
  static const onSecondaryContainer = Color('#003a50');
  static const secondaryFixed = Color('#c3e8ff');
  static const secondaryFixedDim = Color('#7ad0ff');
  static const onSecondaryFixed = Color('#001e2c');
  static const onSecondaryFixedVariant = Color('#004c69');

  static const tertiary = Color('#00daf3');
  static const onTertiary = Color('#00363d');
  static const tertiaryContainer = Color('#007d8c');
  static const onTertiaryContainer = Color('#e7fbff');
  static const tertiaryFixed = Color('#9cf0ff');
  static const tertiaryFixedDim = Color('#00daf3');
  static const onTertiaryFixed = Color('#001f24');
  static const onTertiaryFixedVariant = Color('#004f58');

  static const error = Color('#ffb4ab');
  static const onError = Color('#690005');
  static const errorContainer = Color('#93000a');
  static const onErrorContainer = Color('#ffdad6');
}

extension AppColorAlpha on Color {
  static final _hexPattern = RegExp(r'^#[0-9a-fA-F]{6}$');

  Color alpha(double opacity) {
    final hex = value;
    if (!_hexPattern.hasMatch(hex)) {
      throw ArgumentError.value(hex, 'value', 'alpha() needs a #rrggbb colour');
    }
    final red = int.parse(hex.substring(1, 3), radix: 16);
    final green = int.parse(hex.substring(3, 5), radix: 16);
    final blue = int.parse(hex.substring(5, 7), radix: 16);
    return Color.rgba(red, green, blue, opacity);
  }
}

abstract final class AppBorders {
  static Border hairline(Color color) => Border.all(style: .solid, color: color, width: 1.px);

  static BorderSide hairlineSide(Color color) => BorderSide.solid(color: color, width: 1.px);
}

abstract final class AppFocus {
  static const ring = Outline(
    color: AppColors.tertiary,
    style: .solid,
    width: OutlineWidth(Unit.pixels(2)),
    offset: Unit.pixels(2),
  );
}

abstract final class AppGrid {
  static const singleColumn = GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))]));

  static const twoColumns = GridTemplate(
    columns: GridTracks([
      GridTrack.repeat(TrackRepeat(2), [GridTrack(TrackSize.fr(1))]),
    ]),
  );

  static const threeColumns = GridTemplate(
    columns: GridTracks([
      GridTrack.repeat(TrackRepeat(3), [GridTrack(TrackSize.fr(1))]),
    ]),
  );

  static const fourColumns = GridTemplate(
    columns: GridTracks([
      GridTrack.repeat(TrackRepeat(4), [GridTrack(TrackSize.fr(1))]),
    ]),
  );
}

abstract final class AppFonts {
  static const sans = FontFamily.list([
    FontFamily('Geist'),
    FontFamily('Inter'),
    FontFamilies.systemUi,
  ]);
  static const mono = FontFamily.list([
    FontFamily('JetBrains Mono'),
    FontFamilies.uiMonospace,
  ]);

  static const stylesheet =
      'https://fonts.googleapis.com/css2?family=Geist:wght@400;500;600;700'
      '&family=JetBrains+Mono:wght@400;500;700&display=swap';
}

abstract final class AppType {
  static final display = Styles(
    fontFamily: AppFonts.sans,
    fontSize: 56.px,
    fontWeight: .w700,
    letterSpacing: (-0.03).em,
    lineHeight: 64.px,
  );

  static final displayMobile = Styles(
    fontFamily: AppFonts.sans,
    fontSize: 38.px,
    fontWeight: .w700,
    letterSpacing: (-0.025).em,
    lineHeight: 44.px,
  );

  static final headlineLg = Styles(
    fontFamily: AppFonts.sans,
    fontSize: 36.px,
    fontWeight: .w600,
    letterSpacing: (-0.02).em,
    lineHeight: 44.px,
  );

  static final headlineLgMobile = Styles(
    fontFamily: AppFonts.sans,
    fontSize: 28.px,
    fontWeight: .w600,
    letterSpacing: (-0.02).em,
    lineHeight: 36.px,
  );

  static final headlineMd = Styles(
    fontFamily: AppFonts.sans,
    fontSize: 24.px,
    fontWeight: .w600,
    letterSpacing: (-0.015).em,
    lineHeight: 32.px,
  );

  static final headlineSm = Styles(
    fontFamily: AppFonts.sans,
    fontSize: 20.px,
    fontWeight: .w500,
    letterSpacing: (-0.01).em,
    lineHeight: 28.px,
  );

  static final bodyLg = Styles(
    fontFamily: AppFonts.sans,
    fontSize: 18.px,
    fontWeight: .w400,
    letterSpacing: (-0.005).em,
    lineHeight: 28.px,
  );

  static final bodyMd = Styles(
    fontFamily: AppFonts.sans,
    fontSize: 15.px,
    fontWeight: .w400,
    letterSpacing: 0.em,
    lineHeight: 24.px,
  );

  static final bodySm = Styles(
    fontFamily: AppFonts.sans,
    fontSize: 13.px,
    fontWeight: .w400,
    letterSpacing: 0.005.em,
    lineHeight: 20.px,
  );

  static final codeBlock = Styles(
    fontFamily: AppFonts.mono,
    fontSize: 13.5.px,
    fontWeight: .w400,
    letterSpacing: 0.em,
    lineHeight: 22.px,
  );

  static final labelMd = Styles(
    fontFamily: AppFonts.mono,
    fontSize: 12.px,
    fontWeight: .w500,
    letterSpacing: 0.04.em,
    lineHeight: 16.px,
  );

  static final labelSm = Styles(
    fontFamily: AppFonts.mono,
    fontSize: 10.5.px,
    fontWeight: .w500,
    letterSpacing: 0.06.em,
    lineHeight: 14.px,
  );
}

enum AppAccent {
  primary(AppColors.primary),
  secondary(AppColors.secondary),
  tertiary(AppColors.tertiary);

  const AppAccent(this.color);

  final Color color;
  static AppAccent atPosition(int position) => values[position % values.length];
}

abstract final class AppSpacing {
  static const xxs = Unit.rem(0.25);
  static const xs = Unit.rem(0.5);
  static const sm = Unit.rem(0.75);
  static const md = Unit.rem(1);
  static const lg = Unit.rem(1.5);
  static const xl = Unit.rem(2);
  static const xxl = Unit.rem(3);
  static const xxxl = Unit.rem(4);

  static const gutterMobile = Unit.rem(1);
  static const gutterDesktop = Unit.rem(2);
  static const containerMax = Unit.rem(72);
}

abstract final class AppRadius {
  static const sm = Unit.rem(0.125);
  static const base = Unit.rem(0.25);
  static const md = Unit.rem(0.375);
  static const lg = Unit.rem(0.5);
  static const xl = Unit.rem(0.75);
  static const pill = Unit.pixels(9999);
}

abstract final class AppBreakpoints {
  static const sm = Unit.pixels(640);
  static const md = Unit.pixels(768);
  static const lg = Unit.pixels(1024);

  static final belowSm = MediaQuery.screen(maxWidth: Unit.pixels(639.98));
  static final belowMd = MediaQuery.screen(maxWidth: Unit.pixels(767.98));
  static final belowLg = MediaQuery.screen(maxWidth: Unit.pixels(1023.98));
  static final fromSm = MediaQuery.screen(minWidth: sm);
  static final fromMd = MediaQuery.screen(minWidth: md);
  static final fromLg = MediaQuery.screen(minWidth: lg);

  static const reducedMotion = MediaQuery.raw('(prefers-reduced-motion: reduce)');
}

abstract final class AppMotion {
  static const ambientGlow = 'ambientGlow';
  static const fadeInUp = 'fadeInUp';
  static const entrance = Curve.cubicBezier(0.16, 1, 0.3, 1);

  static const ambient = Curve.cubicBezier(0.4, 0, 0.6, 1);

  static const fast = Duration(milliseconds: 200);

  static const slow = Duration(milliseconds: 300);

  static Transition ease(String property, {Duration duration = fast}) =>
      Transition(property, duration: duration, curve: .easeOut);
}

@css
List<StyleRule> get styles => [
  css.import(AppFonts.stylesheet),

  css('*, *::before, *::after').styles(boxSizing: .borderBox),

  css('html').styles(
    width: 100.percent,
    overflow: .only(x: .hidden),
    raw: {'scroll-behavior': 'smooth', '-webkit-font-smoothing': 'antialiased'},
  ),

  css('body')
      .styles(
        width: 100.percent,
        minHeight: 100.vh,
        padding: .zero,
        margin: .zero,
        overflow: .only(x: .hidden),
        color: AppColors.onSurface,
        backgroundColor: AppColors.cosmosBase,
      )
      .combine(AppType.bodyMd),

  css('h1, h2, h3, h4, h5, h6, p, figure, blockquote').styles(margin: .zero),
  css('ul, ol').styles(padding: .zero, margin: .zero, listStyle: .none),
  css('a').styles(
    color: .inherit,
    textDecoration: const TextDecoration(line: .none),
  ),
  css('img, svg').styles(display: .block, maxWidth: 100.percent),
  css('button, input, select, textarea').styles(
    padding: .zero,
    border: .none,
    color: .inherit,
    fontFamily: .inherit,
    fontSize: .inherit,
    backgroundColor: Colors.transparent,
  ),
  css('button').styles(cursor: .pointer),

  css('::selection').styles(
    color: AppColors.onPrimaryContainer,
    backgroundColor: AppColors.primaryContainer,
  ),

  css(':focus-visible').styles(outline: AppFocus.ring),

  // Horizontal longhands only. A caller adding vertical padding must pass
  // `Spacing.symmetric(vertical:)` alone — both axes emit the `padding` shorthand over these.
  css('.app-container').styles(
    maxWidth: AppSpacing.containerMax,
    padding: .symmetric(horizontal: AppSpacing.gutterMobile),
    margin: .symmetric(horizontal: Unit.auto),
  ),

  css('.sr-only').styles(
    position: .absolute(),
    width: 1.px,
    height: 1.px,
    padding: .zero,
    margin: .all((-1).px),
    border: .none,
    overflow: .hidden,
    whiteSpace: .noWrap,
    raw: {'clip-path': 'inset(50%)'},
  ),

  css('.skip-link', [
    css('&').styles(
      position: .absolute(),
      width: 1.px,
      height: 1.px,
      overflow: .hidden,
      whiteSpace: .noWrap,
      raw: {'clip-path': 'inset(50%)'},
    ),
    css('&:focus')
        .combine(AppType.labelMd)
        .styles(
          position: .fixed(top: AppSpacing.md, left: AppSpacing.md),
          zIndex: const ZIndex(100),
          width: .auto,
          height: .auto,
          padding: .symmetric(vertical: AppSpacing.xs, horizontal: AppSpacing.md),
          radius: .circular(AppRadius.base),
          overflow: .visible,
          color: AppColors.onTertiary,
          fontWeight: .w700,
          backgroundColor: AppColors.tertiary,
          raw: {'clip-path': 'none'},
        ),
  ]),

  css.keyframes(AppMotion.ambientGlow, {
    '0%, 100%': Styles(
      opacity: 0.55,
      transform: .combine([.translate(x: (-50).percent, y: (-10).percent), .scale(1)]),
    ),
    '50%': Styles(
      opacity: 0.85,
      filter: .blur(95.px),
      transform: .combine([.translate(x: (-50).percent, y: (-6).percent), .scale(1.12)]),
    ),
  }),

  css.keyframes(AppMotion.fadeInUp, {
    'from': Styles(opacity: 0, transform: .translate(y: 16.px)),
    'to': Styles(opacity: 1, transform: .translate(y: 0.px)),
  }),

  css('.animate-ambient-pulse').styles(
    animation: Animation(
      name: AppMotion.ambientGlow,
      duration: 8.seconds,
      curve: AppMotion.ambient,
    ),
    // `Animation` has no infinite option and its shorthand resets the count to 1, so the longhand
    // follows it — `raw` is rendered last, which is what makes that work.
    raw: {'animation-iteration-count': 'infinite'},
  ),
  css('.animate-fade-in-up').styles(
    opacity: 0,
    animation: Animation(
      name: AppMotion.fadeInUp,
      duration: 700.ms,
      curve: AppMotion.entrance,
      fillMode: .forwards,
    ),
  ),
  css('.delay-100').styles(raw: {'animation-delay': '100ms'}),
  css('.delay-200').styles(raw: {'animation-delay': '200ms'}),
  css('.delay-300').styles(raw: {'animation-delay': '300ms'}),

  css.media(AppBreakpoints.fromLg, [
    css('.app-container').styles(padding: .symmetric(horizontal: AppSpacing.gutterDesktop)),
  ]),

  // Colour feedback survives on purpose — it is the only hover cue left once the lifts are gone.
  css.media(AppBreakpoints.reducedMotion, [
    css('*, *::before, *::after').styles(
      raw: {
        'animation-duration': '0.01ms !important',
        'animation-iteration-count': '1 !important',
        'transition-duration': '0.01ms !important',
        'scroll-behavior': 'auto !important',
        'transform': 'none !important',
      },
    ),
    css('.animate-fade-in-up').styles(opacity: 1),
  ]),
];
