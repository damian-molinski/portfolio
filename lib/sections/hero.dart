import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/copy_email_button.dart';
import '../components/icons.dart';
import '../components/mono_button.dart';
import '../components/status_dot.dart';
import '../constants/theme.dart';
import '../content/site_content.dart';
import '../state/site_content_builder.dart';

class Hero extends StatelessComponent {
  const Hero({super.key});

  @override
  Component build(BuildContext context) {
    return SiteContentBuilder(builder: (context, content) => _section(content.hero));
  }

  Component _section(HeroContent hero) {
    return section(classes: 'hero', [
      div(
        classes: 'hero__ambient',
        attributes: const {'aria-hidden': 'true'},
        [
          div(classes: 'hero__glow animate-ambient-pulse', []),
          div(classes: 'hero__glow-secondary', []),
          div(classes: 'hero__vignette', []),
        ],
      ),

      div(classes: 'hero__container app-container', [
        div(classes: 'hero__content animate-fade-in-up', [
          div(classes: 'hero__pill', [
            const StatusDot(),
            span(classes: 'hero__pill-label', [.text(hero.statusPill)]),
          ]),

          div(classes: 'hero__headline', [
            h1(classes: 'hero__title', [
              .text('${hero.headlineLead} '),
              span(classes: 'hero__title-accent', [.text(hero.headlineAccent)]),
            ]),
            p(classes: 'hero__tagline', [.text(hero.tagline)]),
          ]),

          p(classes: 'hero__body', [.text(hero.body)]),

          div(classes: 'hero__actions', [
            MonoButton.link(
              label: hero.primaryCta,
              href: SiteSection.contact.anchor,
              icon: AppIcon.send,
              ariaLabel: hero.primaryCtaAriaLabel,
            ),
            const CopyEmailButton(isIconOnly: false),
          ]),

          div(classes: 'hero__telemetry', [
            span(classes: 'hero__availability', [
              const StatusDot(),
              span([.text(hero.availability)]),
            ]),
            span(attributes: const {'aria-hidden': 'true'}, [.text('•')]),
            span([.text(hero.locations)]),
          ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.hero', [
      css('&').styles(
        display: .block,
        position: .relative(),
        width: 100.percent,
        border: Border.only(
          bottom: AppBorders.hairlineSide(AppColors.surfaceContainerHigh.alpha(0.3)),
        ),
        overflow: .hidden,
      ),

      css('.hero__ambient').styles(
        position: .absolute(top: .zero, left: .zero, right: .zero, bottom: .zero),
        pointerEvents: .none,
      ),

      css('.hero__glow').styles(
        position: .absolute(top: (-8).rem, left: 50.percent),
        width: 920.px,
        height: 500.px,
        radius: .all(.circular(AppRadius.pill)),
        filter: .blur(90.px),
        raw: {
          'background-image':
              'linear-gradient(to bottom, ${AppColors.primary.alpha(0.25).value}, '
              '${AppColors.tertiary.alpha(0.15).value}, transparent)',
        },
      ),

      css('.hero__glow-secondary').styles(
        position: .absolute(top: 16.rem, left: 50.percent),
        width: 560.px,
        height: 280.px,
        margin: .only(left: (-280).px),
        radius: .all(.circular(AppRadius.pill)),
        filter: .blur(100.px),
        backgroundColor: AppColors.secondaryContainer.alpha(0.15),
      ),

      css('.hero__vignette').styles(
        position: .absolute(top: .zero, left: .zero, right: .zero, bottom: .zero),
        opacity: 0.85,
        raw: {
          'background-image': 'radial-gradient(circle at center, transparent 0%, ${AppColors.surface.value} 75%)',
        },
      ),

      css('.hero__container').styles(
        position: .relative(),
        // Vertical only — `.app-container` owns the horizontal gutter as longhands.
        padding: .symmetric(vertical: AppSpacing.xxl),
      ),

      css('.hero__content').styles(
        display: .flex,
        maxWidth: 48.rem,
        margin: .symmetric(horizontal: Unit.auto),
        flexDirection: .column,
        alignItems: .center,
        gap: Gap(row: AppSpacing.md),
        textAlign: .center,
      ),

      css('.hero__pill').styles(
        display: .inlineFlex,
        padding: .symmetric(vertical: AppSpacing.xxs, horizontal: AppSpacing.sm),
        border: AppBorders.hairline(AppColors.tertiary.alpha(0.3)),
        radius: .all(.circular(AppRadius.pill)),
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: .zero,
          blur: 15.px,
          color: AppColors.tertiary.alpha(0.12),
        ),
        backdropFilter: .blur(12.px),
        alignItems: .center,
        gap: Gap(column: AppSpacing.xs),
        backgroundColor: AppColors.surfaceContainerLow.alpha(0.6),
      ),
      css('.hero__pill-label')
          .combine(AppType.labelSm)
          .styles(
            color: AppColors.primary,
            textTransform: .upperCase,
            letterSpacing: 0.1.em,
          ),

      css('.hero__headline').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap(row: AppSpacing.xs),
      ),

      // The 56px display step overflows a 360px viewport, so the mobile variant is the base and the
      // desktop one arrives at 640px.
      css('.hero__title').combine(AppType.displayMobile).styles(color: AppColors.onSurface, lineHeight: 1.05.em),
      css('.hero__title-accent').styles(
        color: Colors.transparent,
        raw: {
          'background-image':
              'linear-gradient(to right, ${AppColors.primary.value}, '
              '${AppColors.secondary.value}, ${AppColors.tertiary.value})',
          '-webkit-background-clip': 'text',
          'background-clip': 'text',
          '-webkit-text-fill-color': 'transparent',
          'filter': 'drop-shadow(0 0 24px ${AppColors.primary.alpha(0.25).value})',
        },
      ),

      css('.hero__tagline').combine(AppType.headlineSm).styles(color: AppColors.onSurfaceVariant, fontWeight: .w400),

      css('.hero__body').combine(AppType.bodyMd).styles(maxWidth: 42.rem, color: AppColors.onSurfaceVariant.alpha(0.8)),

      css('.hero__actions').styles(
        display: .flex,
        padding: .only(top: AppSpacing.xxs),
        flexWrap: .wrap,
        justifyContent: .center,
        alignItems: .center,
        gap: Gap(row: AppSpacing.sm, column: AppSpacing.sm),
      ),

      css('.hero__telemetry')
          .combine(AppType.labelSm)
          .styles(
            display: .flex,
            padding: .only(top: AppSpacing.xxs),
            flexWrap: .wrap,
            justifyContent: .center,
            alignItems: .center,
            gap: Gap(row: AppSpacing.xxs, column: AppSpacing.sm),
            color: AppColors.onSurfaceVariant,
          ),
      css('.hero__availability').styles(
        display: .inlineFlex,
        alignItems: .center,
        gap: Gap(column: AppSpacing.xxs),
        color: AppColors.tertiary,
      ),
    ]),

    css.media(AppBreakpoints.fromSm, [
      css('.hero .hero__title').combine(AppType.display).styles(lineHeight: 1.05.em),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.hero .hero__container').styles(padding: .symmetric(vertical: AppSpacing.xxxl)),
    ]),

    // The global reduced-motion rule zeroes every transform, including the keyframe's
    // `translate(-50%, -10%)` that centres this blob — so layout has to centre it instead.
    css.media(AppBreakpoints.reducedMotion, [
      css('.hero .hero__glow').styles(
        margin: .only(top: (-50).px, left: (-460).px),
      ),
    ]),
  ];
}
