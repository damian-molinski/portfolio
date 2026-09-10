import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

/// The heading block that opens each of the four numbered sections.
///
/// An eyebrow over an `h2`, with an optional standfirst beneath and an optional status note pushed to
/// the right on wide viewports. The note drops below 640px, where there is no room to set it beside
/// the heading — the design hides it rather than stacking it.
class SectionHeading extends StatelessComponent {
  const SectionHeading({
    required this.eyebrow,
    required this.title,
    this.lead,
    this.note,
    super.key,
  });

  /// The small uppercase line above the heading, e.g. the section's ordinal and label.
  final String eyebrow;

  final String title;

  /// A single line of setup beneath the heading. Two of the four sections have one.
  final String? lead;

  /// A right-aligned status note. Hidden below 640px.
  final String? note;

  @override
  Component build(BuildContext context) {
    return div(classes: 'section-heading', [
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
      css('.section-heading__title').combine(AppType.headlineLg).styles(color: AppColors.onSurface),
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

    // From 640px the note has room to sit beside the heading.
    css.media(AppBreakpoints.fromSm, [
      css('.section-heading .section-heading__note').styles(display: .block),
    ]),

    // From 768px the heading and its note share a baseline-aligned row.
    css.media(AppBreakpoints.fromMd, [
      css('.section-heading').styles(flexDirection: .row, alignItems: .end),
    ]),
  ];
}
