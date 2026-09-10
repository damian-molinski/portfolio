import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/contact_form.dart';
import '../components/copy_email_button.dart';
import '../components/section_heading.dart';
import '../components/section_shell.dart';
import '../constants/theme.dart';
import '../content/site_content.dart';

/// Section `04` — the consultation panel.
///
/// One panel rather than a section of loose blocks: a header strip carrying the heading and three
/// summary cards, then the form console beneath it on a lighter ground. The form sends nothing —
/// decision D5, and [ContactForm] says why.
class Contact extends StatelessComponent {
  const Contact({super.key});

  Component _summaryCard(ContactCard card) {
    final accent = AppAccent.atPosition(card.index);

    return div(classes: 'contact__card', [
      card.icon(classes: 'contact__card-glyph contact__card-glyph--${accent.name}'),
      div(classes: 'contact__card-text', [
        span(classes: 'contact__card-label', [.text(card.label)]),
        if (card.href case final href?)
          a(
            classes: 'contact__card-value contact__card-value--link',
            href: href,
            [.text(card.value)],
          )
        else
          span(classes: 'contact__card-value', [.text(card.value)]),
      ]),
      if (card.isCopyable)
        const CopyEmailButton(
          email: SiteIdentity.email,
          successLabel: HeroContent.copyCtaSuccess,
          ariaLabel: HeroContent.copyCtaAriaLabel,
        ),
    ]);
  }

  @override
  Component build(BuildContext context) {
    return SectionShell(
      siteSection: SiteSection.contact,
      hasDivider: false,
      children: [
        div(classes: 'contact__panel', [
          div(
            classes: 'contact__glow',
            attributes: const {'aria-hidden': 'true'},
            const [],
          ),

          div(classes: 'contact__header', [
            SectionHeading.forSection(SiteSection.contact),
            div(classes: 'contact__cards', [
              for (final card in ContactCard.values) _summaryCard(card),
            ]),
          ]),

          div(classes: 'contact__console', [const ContactForm()]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.contact__panel', [
      css('&').styles(
        position: .relative(),
        maxWidth: 56.rem,
        margin: .symmetric(horizontal: Unit.auto),
        border: Border.all(
          style: .solid,
          color: AppColors.surfaceContainerHigh.alpha(0.6),
          width: 1.px,
        ),
        radius: .all(.circular(AppRadius.xl)),
        overflow: .hidden,
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: 24.px,
          blur: 48.px,
          color: const Color.rgba(0, 0, 0, 0.35),
        ),
        backgroundColor: AppColors.surfaceContainerLow,
      ),

      css('.contact__glow').styles(
        position: .absolute(top: (-5).rem, right: (-5).rem),
        width: 18.rem,
        height: 18.rem,
        radius: .all(.circular(AppRadius.pill)),
        filter: .blur(64.px),
        pointerEvents: .none,
        backgroundColor: AppColors.primaryContainer.alpha(0.1),
      ),

      css('.contact__header').styles(
        display: .flex,
        position: .relative(),
        padding: .all(AppSpacing.lg),
        border: Border.only(
          bottom: BorderSide.solid(color: AppColors.surfaceContainerHigh.alpha(0.6), width: 1.px),
        ),
        flexDirection: .column,
        gap: Gap(row: AppSpacing.sm),
        backgroundColor: AppColors.surfaceContainerLowest.alpha(0.5),
      ),

      css('.contact__cards').styles(
        display: .grid,
        gridTemplate: const GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
        gap: Gap(row: AppSpacing.xs, column: AppSpacing.xs),
      ),
      css('.contact__card').styles(
        display: .flex,
        padding: .all(AppSpacing.sm),
        border: Border.all(
          style: .solid,
          color: AppColors.surfaceContainerHigh.alpha(0.5),
          width: 1.px,
        ),
        radius: .all(.circular(AppRadius.lg)),
        transition: Transition('all', duration: 200.ms, curve: .easeOut),
        alignItems: .center,
        gap: Gap(column: AppSpacing.sm),
        backgroundColor: AppColors.surfaceContainer,
      ),
      css('.contact__card:hover').styles(
        border: Border.all(style: .solid, color: AppColors.tertiary.alpha(0.5), width: 1.px),
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: .zero,
          blur: 15.px,
          color: AppColors.tertiary.alpha(0.1),
        ),
      ),

      css('.contact__card-glyph').styles(
        transition: Transition('color', duration: 200.ms, curve: .easeOut),
        fontSize: 20.px,
      ),
      for (final accent in AppAccent.values) css('.contact__card-glyph--${accent.name}').styles(color: accent.color),
      css('.contact__card:hover .contact__card-glyph').styles(color: AppColors.tertiary),

      css('.contact__card-text').styles(
        display: .flex,
        minWidth: .zero,
        flexDirection: .column,
        flex: const Flex(grow: 1, shrink: 1, basis: .zero),
      ),
      css('.contact__card-label').combine(AppType.labelSm).styles(color: AppColors.onSurfaceVariant),
      css('.contact__card-value')
          .combine(AppType.bodySm)
          .styles(
            overflow: .hidden,
            transition: Transition('color', duration: 200.ms, curve: .easeOut),
            color: AppColors.onSurface,
            textOverflow: .ellipsis,
            whiteSpace: .noWrap,
          ),
      css('.contact__card-value--link:hover').styles(color: AppColors.tertiary),

      css('.contact__console').styles(
        position: .relative(),
        padding: .all(AppSpacing.lg),
        backgroundColor: AppColors.surfaceContainer,
      ),
    ]),

    css.media(AppBreakpoints.fromMd, [
      css('.contact__panel .contact__cards').styles(
        gridTemplate: const GridTemplate(
          columns: GridTracks([
            GridTrack.repeat(TrackRepeat(3), [GridTrack(TrackSize.fr(1))]),
          ]),
        ),
      ),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.contact__panel .contact__header').styles(padding: .all(AppSpacing.xl)),
      css('.contact__panel .contact__console').styles(padding: .all(AppSpacing.xl)),
    ]),
  ];
}
