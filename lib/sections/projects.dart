import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icons.dart';
import '../components/section_heading.dart';
import '../components/section_shell.dart';
import '../components/spec_card.dart';
import '../components/status_dot.dart';
import '../components/tag_pill.dart';
import '../constants/theme.dart';
import '../content/site_content.dart';
import '../data/site_content_repository.dart';
import '../state/bloc_builder.dart';
import '../state/site_content_cubit.dart';
import '../state/site_content_state.dart';

/// Section `03` — the three case-study cards.
///
/// Taller than the pillars and skills cards because each carries a telemetry readout between its
/// body and its tags, and a link out below them.
class Projects extends StatelessComponent {
  const Projects({super.key});

  Component _card(Project project, ProjectContent labels) {
    return SpecCard(
      minHeight: 360.px,
      classes: 'project-card',
      children: [
        div(classes: 'project-card__head', [
          div(classes: 'project-card__top', [
            span(classes: 'project-card__category', [.text(project.category)]),
            span(classes: 'project-card__status', [
              const StatusDot(tone: StatusDotTone.pulse),
              .text(labels.activeLabel),
            ]),
          ]),

          div(classes: 'project-card__text', [
            h3(classes: 'project-card__title', [.text(project.title)]),
            p(classes: 'project-card__body', [.text(project.body)]),
          ]),

          div(classes: 'project-card__telemetry', [
            span(classes: 'project-card__telemetry-label', [.text(labels.telemetryLabel)]),
            span(classes: 'project-card__telemetry-value', [.text(project.telemetry)]),
          ]),
        ]),

        div(classes: 'project-card__footer', [
          div(classes: 'project-card__tags', [
            for (final tag in project.tags) TagPill(tag),
          ]),
          a(
            classes: 'project-card__link',
            href: project.href,
            target: .blank,
            attributes: {'rel': 'noopener noreferrer', 'aria-label': project.linkAriaLabel},
            [
              span([.text(labels.viewLabel)]),
              AppIcon.northEast(classes: 'project-card__link-glyph'),
            ],
          ),
        ]),
      ],
    );
  }

  @override
  Component build(BuildContext context) {
    return BlocBuilder<SiteContentCubit, SiteContentState>(
      builder: (context, state) => _section(state.content),
    );
  }

  Component _section(SiteContent content) {
    return SectionShell(
      siteSection: SiteSection.projects,
      children: [
        SectionHeading.forSection(SiteSection.projects),
        div(classes: 'project-grid', [
          for (final project in content.projects) _card(project, content.projectLabels),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.project-grid', [
      css('&').styles(
        display: .grid,
        gridTemplate: const GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
        gap: Gap(row: AppSpacing.md, column: AppSpacing.md),
      ),
    ]),

    css('.project-card', [
      css('.project-card__head').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap(row: AppSpacing.md),
      ),
      css('.project-card__top').styles(
        display: .flex,
        flexWrap: .wrap,
        justifyContent: .spaceBetween,
        alignItems: .center,
        gap: Gap(row: AppSpacing.xxs, column: AppSpacing.xs),
      ),
      css('.project-card__category')
          .combine(AppType.labelSm)
          .styles(
            color: AppColors.primary,
            fontFamily: AppFonts.mono,
            textTransform: .upperCase,
            letterSpacing: 0.08.em,
          ),
      css('.project-card__status')
          .combine(AppType.labelSm)
          .styles(
            display: .inlineFlex,
            alignItems: .center,
            gap: Gap(column: AppSpacing.xxs),
            color: AppColors.tertiary,
            fontFamily: AppFonts.mono,
          ),

      css('.project-card__text').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap(row: AppSpacing.xxs),
      ),
      css('.project-card__title')
          .combine(AppType.headlineSm)
          .styles(
            transition: Transition('color', duration: 200.ms, curve: .easeOut),
            color: AppColors.onSurface,
          ),
      css('&:hover .project-card__title').styles(color: AppColors.tertiaryFixed),
      css('.project-card__body').combine(AppType.bodySm).styles(color: AppColors.onSurfaceVariant),

      css('.project-card__telemetry').styles(
        display: .flex,
        padding: .all(AppSpacing.sm),
        border: Border.all(
          style: .solid,
          color: AppColors.surfaceContainerHigh.alpha(0.5),
          width: 1.px,
        ),
        radius: .all(.circular(AppRadius.lg)),
        flexDirection: .column,
        gap: Gap(row: AppSpacing.xxs),
        backgroundColor: AppColors.surfaceContainerLowest.alpha(0.7),
      ),
      css('.project-card__telemetry-label')
          .combine(AppType.labelSm)
          .styles(
            color: AppColors.outline,
            textTransform: .upperCase,
            letterSpacing: 0.08.em,
          ),
      css('.project-card__telemetry-value')
          .combine(AppType.labelSm)
          .styles(
            color: AppColors.tertiary.alpha(0.9),
            fontFamily: AppFonts.mono,
          ),

      css('.project-card__footer').styles(
        display: .flex,
        padding: .only(top: AppSpacing.md),
        margin: .only(top: AppSpacing.md),
        border: Border.only(
          top: BorderSide.solid(color: AppColors.surfaceContainerHigh.alpha(0.4), width: 1.px),
        ),
        flexDirection: .column,
        gap: Gap(row: AppSpacing.sm),
      ),
      css('.project-card__tags').styles(
        display: .flex,
        flexWrap: .wrap,
        gap: Gap(row: AppSpacing.xxs, column: AppSpacing.xxs),
      ),

      css('.project-card__link')
          .combine(AppType.labelSm)
          .styles(
            display: .inlineFlex,
            width: .fitContent,
            radius: .all(.circular(AppRadius.base)),
            transition: Transition('color', duration: 200.ms, curve: .easeOut),
            alignItems: .center,
            gap: Gap(column: AppSpacing.xs),
            color: AppColors.primary,
          ),
      css('&:hover .project-card__link').styles(color: AppColors.tertiary),
      css('.project-card__link-glyph').styles(
        transition: Transition('transform', duration: 200.ms, curve: .easeOut),
        fontSize: 13.px,
      ),
      css('&:hover .project-card__link-glyph').styles(
        transform: .translate(x: 2.px, y: (-2).px),
      ),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.project-grid').styles(
        gridTemplate: const GridTemplate(
          columns: GridTracks([
            GridTrack.repeat(TrackRepeat(3), [GridTrack(TrackSize.fr(1))]),
          ]),
        ),
      ),
    ]),
  ];
}
