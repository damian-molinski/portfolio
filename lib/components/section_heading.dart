import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../content/site_content.dart';

class SectionHeading extends StatelessComponent {
  const SectionHeading({
    required this.eyebrow,
    required this.title,
    this.lead,
    this.note,
    super.key,
  });

  SectionHeading.forSection(SiteSection section, {super.key})
    : eyebrow = section.eyebrowLine,
      title = section.title,
      lead = section.lead,
      note = section.note;
  final String eyebrow;

  final String title;
  final String? lead;
  final String? note;

  @override
  Component build(BuildContext context) {
    return div(classes: 'section-heading animate-fade-in-up', [
      div(classes: 'section-heading__text', [
        span(classes: 'section-heading__eyebrow', [.text(eyebrow)]),
        h2(classes: 'section-heading__title', [.text(title)]),
        if (lead case final lead?) p(classes: 'section-heading__lead', [.text(lead)]),
      ]),
      if (note case final note?) span(classes: 'section-heading__note', [.text(note)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.section-heading', [
      css('&').styles(
        display: .flex,
        margin: .only(bottom: AppSpacing.xl),
        flexDirection: .column,
        justifyContent: .spaceBetween,
        gap: Gap(row: AppSpacing.sm),
      ),
      css('.section-heading__text').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap(row: AppSpacing.xxs),
      ),
      css('.section-heading__eyebrow')
          .combine(AppType.labelSm)
          .styles(
            color: AppColors.primary,
            textTransform: .upperCase,
            letterSpacing: 0.1.em,
          ),
      // Mobile step is the base; the 36px step arrives at 640px.
      css('.section-heading__title')
          .combine(AppType.headlineLgMobile)
          .styles(
            color: AppColors.onSurface,
          ),
      css('.section-heading__lead')
          .combine(AppType.bodyMd)
          .styles(
            maxWidth: 44.rem,
            color: AppColors.onSurfaceVariant,
          ),
      css('.section-heading__note')
          .combine(AppType.labelSm)
          .styles(
            display: .none,
            color: AppColors.outline,
            textTransform: .upperCase,
            letterSpacing: 0.08.em,
          ),
    ]),

    css.media(AppBreakpoints.fromSm, [
      css('.section-heading .section-heading__title').combine(AppType.headlineLg),
      css('.section-heading .section-heading__note').styles(display: .block),
    ]),

    css.media(AppBreakpoints.fromMd, [
      css('.section-heading').styles(flexDirection: .row, alignItems: .end),
    ]),
  ];
}
