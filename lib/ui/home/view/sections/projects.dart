import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../../domain/models/site_content.dart';
import '../../../../utils/markup.dart';
import '../../../core/binding/bloc_builder.dart';
import '../../../core/components/icons.dart';
import '../../../core/components/section_heading.dart';
import '../../../core/components/section_shell.dart';
import '../../../core/components/spec_card.dart';
import '../../../core/components/tag_pill.dart';
import '../../../core/theme.dart';
import '../../view_model/home_state.dart';
import '../../view_model/home_view_model.dart';

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

        if (project.href case final String href)
          div(classes: 'project-card__footer', [
            div(classes: 'project-card__tags', [
              for (final tag in project.tags) TagPill(tag),
            ]),
            a(
              classes: 'project-card__link',
              href: href,
              target: .blank,
              attributes: externalLinkAttributes(ariaLabel: project.linkAriaLabel),
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
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) => _section(state),
    );
  }

  Component _section(HomeState state) {
    return SectionShell(
      siteSection: SiteSection.projects,
      children: [
        SectionHeading.forSection(SiteSection.projects),
        div(classes: 'project-grid', [
          for (final project in state.projects) _card(project, state.projectLabels),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.project-grid', [
      css('&').styles(
        display: .grid,
        gridTemplate: AppGrid.singleColumn,
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
      css('.project-card__text').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap(row: AppSpacing.xxs),
      ),
      css('.project-card__title')
          .combine(AppType.headlineSm)
          .styles(
            transition: AppMotion.ease('color'),
            color: AppColors.onSurface,
          ),
      css('&:hover .project-card__title').styles(color: AppColors.tertiaryFixed),
      css('.project-card__body').combine(AppType.bodySm).styles(color: AppColors.onSurfaceVariant),

      css('.project-card__telemetry').styles(
        display: .flex,
        padding: .all(AppSpacing.sm),
        border: AppBorders.hairline(AppColors.surfaceContainerHigh.alpha(0.5)),
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
          top: AppBorders.hairlineSide(AppColors.surfaceContainerHigh.alpha(0.4)),
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
            transition: AppMotion.ease('color'),
            alignItems: .center,
            gap: Gap(column: AppSpacing.xs),
            color: AppColors.primary,
          ),
      css('&:hover .project-card__link').styles(color: AppColors.tertiary),
      css('.project-card__link-glyph').styles(
        transition: AppMotion.ease('transform'),
        fontSize: 13.px,
      ),
      css('&:hover .project-card__link-glyph').styles(
        transform: .translate(x: 2.px, y: (-2).px),
      ),
    ]),

    css.media(AppBreakpoints.fromLg, [
      css('.project-grid').styles(
        gridTemplate: AppGrid.threeColumns,
      ),
    ]),
  ];
}
