import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../../domain/models/site_content.dart';
import '../../../../utils/markup.dart';
import '../../../contact/view/contact_form.dart';
import '../../../copy_email/view/copy_email_button.dart';
import '../../../core/components/section_heading.dart';
import '../../../core/components/section_shell.dart';
import '../../../core/theme.dart';
import '../../../core/view_model/site_content_builder.dart';

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
            target: card.isExternal ? .blank : null,
            attributes: card.isExternal ? externalLinkAttributes() : null,
            [.text(card.value)],
          )
        else
          span(classes: 'contact__card-value', [.text(card.value)]),
      ]),
      if (card.isCopyable) const CopyEmailButton(isIconOnly: true),
    ]);
  }

  @override
  Component build(BuildContext context) {
    return SiteContentBuilder(builder: (context, content) => _section(content));
  }

  Component _section(SiteContent content) {
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
              for (final card in content.contactCards) _summaryCard(card),
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
        border: AppBorders.hairline(AppColors.surfaceContainerHigh.alpha(0.6)),
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
          bottom: AppBorders.hairlineSide(AppColors.surfaceContainerHigh.alpha(0.6)),
        ),
        flexDirection: .column,
        gap: Gap(row: AppSpacing.sm),
        backgroundColor: AppColors.surfaceContainerLowest.alpha(0.5),
      ),

      css('.contact__cards').styles(
        display: .grid,
        gridTemplate: AppGrid.singleColumn,
        gap: Gap(row: AppSpacing.xs, column: AppSpacing.xs),
      ),
      css('.contact__card').styles(
        display: .flex,
        padding: .all(AppSpacing.sm),
        border: AppBorders.hairline(AppColors.surfaceContainerHigh.alpha(0.5)),
        radius: .all(.circular(AppRadius.lg)),
        transition: AppMotion.ease('all'),
        alignItems: .center,
        gap: Gap(column: AppSpacing.sm),
        backgroundColor: AppColors.surfaceContainer,
      ),
      css('.contact__card:hover').styles(
        border: AppBorders.hairline(AppColors.tertiary.alpha(0.5)),
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: .zero,
          blur: 15.px,
          color: AppColors.tertiary.alpha(0.1),
        ),
      ),

      css('.contact__card-glyph').styles(
        transition: AppMotion.ease('color'),
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
            transition: AppMotion.ease('color'),
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
        gridTemplate: AppGrid.threeColumns,
      ),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.contact__panel .contact__header').styles(padding: .all(AppSpacing.xl)),
      css('.contact__panel .contact__console').styles(padding: .all(AppSpacing.xl)),
    ]),
  ];
}
