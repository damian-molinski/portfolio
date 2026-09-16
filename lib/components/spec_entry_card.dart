import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../content/site_content.dart';
import 'spec_card.dart';
import 'tag_pill.dart';

/// A card for one [SpecEntry] — one pillar, or one skill group.
///
/// The design draws both sections with the same card and varies only the data and the pill
/// treatment, so this draws both. It also owns the grid the cards sit in, because the two sections
/// lay them out identically: one column, two from 768px, four from 1024px.
class SpecEntryCard extends StatelessComponent {
  const SpecEntryCard(this.entry, {required this.tagVariant, super.key});

  final SpecEntry entry;

  /// Pillars carry three borderless pills; skills carry five, which need edges to read as a group.
  final TagPillVariant tagVariant;

  /// The tile takes its colour from where the card sits in the row, not from what it says.
  String get _tileClasses {
    final accent = AppAccent.atPosition(entry.index);
    return 'spec-entry__tile spec-entry__tile--${accent.name}';
  }

  @override
  Component build(BuildContext context) {
    return SpecCard(
      classes: 'spec-entry',
      children: [
        div(classes: 'spec-entry__head', [
          div(classes: 'spec-entry__top', [
            div(classes: _tileClasses, [entry.icon(classes: 'spec-entry__glyph')]),
            span(classes: 'spec-entry__index', [.text(entry.indexLabel)]),
          ]),
          div(classes: 'spec-entry__text', [
            h3(classes: 'spec-entry__title', [.text(entry.title)]),
            p(classes: 'spec-entry__body', [.text(entry.body)]),
          ]),
        ]),
        div(classes: 'spec-entry__tags', [
          for (final tag in entry.tags) TagPill(tag, variant: tagVariant),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.spec-entry-grid', [
      css('&').styles(
        display: .grid,
        gridTemplate: AppGrid.singleColumn,
        gap: Gap(row: AppSpacing.md, column: AppSpacing.md),
      ),
    ]),

    css('.spec-entry', [
      css('.spec-entry__head').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap(row: AppSpacing.md),
      ),
      css('.spec-entry__top').styles(
        display: .flex,
        justifyContent: .spaceBetween,
        alignItems: .center,
        gap: Gap(column: AppSpacing.xs),
      ),

      css('.spec-entry__tile').styles(
        display: .flex,
        width: 40.px,
        height: 40.px,
        radius: .all(.circular(AppRadius.lg)),
        transition: AppMotion.ease('all', duration: AppMotion.slow),
        justifyContent: .center,
        alignItems: .center,
        flex: const Flex(grow: 0, shrink: 0, basis: .auto),
        fontSize: 20.px,
        backgroundColor: AppColors.surfaceContainerHigh,
      ),
      for (final accent in AppAccent.values) css('.spec-entry__tile--${accent.name}').styles(color: accent.color),
      // The design drives these off Tailwind's `group-hover`; `@css` is globalised, so the card's own
      // hover state is the selector instead.
      css('&:hover .spec-entry__tile').styles(
        transform: .rotate(6.deg),
        color: AppColors.tertiary,
        backgroundColor: AppColors.tertiaryContainer.alpha(0.4),
      ),

      css('.spec-entry__index')
          .combine(AppType.labelSm)
          .styles(
            transition: AppMotion.ease('color'),
            color: AppColors.onSurfaceVariant,
            fontFamily: AppFonts.mono,
            whiteSpace: .noWrap,
          ),
      css('&:hover .spec-entry__index').styles(color: AppColors.tertiary),

      css('.spec-entry__text').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap(row: AppSpacing.xxs),
      ),
      css('.spec-entry__title')
          .combine(AppType.headlineSm)
          .styles(
            transition: AppMotion.ease('color'),
            color: AppColors.onSurface,
          ),
      css('&:hover .spec-entry__title').styles(color: AppColors.tertiaryFixed),
      css('.spec-entry__body').combine(AppType.bodySm).styles(color: AppColors.onSurfaceVariant),

      css('.spec-entry__tags').styles(
        display: .flex,
        padding: .only(top: AppSpacing.md),
        margin: .only(top: AppSpacing.md),
        border: Border.only(
          top: AppBorders.hairlineSide(AppColors.surfaceContainerHigh.alpha(0.4)),
        ),
        flexWrap: .wrap,
        gap: Gap(row: AppSpacing.xxs, column: AppSpacing.xxs),
      ),
    ]),

    css.media(AppBreakpoints.fromMd, [
      css('.spec-entry-grid').styles(
        gridTemplate: AppGrid.twoColumns,
      ),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.spec-entry-grid').styles(
        gridTemplate: AppGrid.fourColumns,
      ),
    ]),
  ];
}
