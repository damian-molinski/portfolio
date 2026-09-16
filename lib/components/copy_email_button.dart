import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../data/site_content_repository.dart';
import '../di/injector.dart';
import '../state/bloc_builder.dart';
import '../state/copy_cubit.dart';
import '../state/copy_state.dart';
import '../state/site_content_builder.dart';
import '../state/site_content_cubit.dart';
import 'icons.dart';
import 'mono_button.dart';

@client
class CopyEmailButton extends StatefulComponent {
  // Unnamed, because that is the constructor Jaspr's hydration codegen calls. A named one analyzes
  // clean and pre-renders correctly, then fails the client build.
  const CopyEmailButton({required this.isIconOnly, super.key});

  final bool isIconOnly;

  @override
  State<CopyEmailButton> createState() => CopyEmailButtonState();
}

class CopyEmailButtonState extends State<CopyEmailButton> {
  late final SiteContentCubit _siteContent;
  late final CopyCubit _copy;

  @override
  void initState() {
    super.initState();

    _siteContent = getIt<SiteContentCubit>();
    _copy = getIt<CopyCubit>();
  }

  @override
  void dispose() {
    _copy.close();
    super.dispose();
  }

  Component _button(SiteContent content, CopyState copyState) {
    final hero = content.hero;
    void onCopy() => _copy.copy(content.identity.email);

    if (component.isIconOnly) {
      return button(
        classes: 'copy-icon-button',
        type: .button,
        attributes: {'aria-label': hero.copyCtaAriaLabel},
        events: events(onClick: onCopy),
        [
          if (copyState.isCopied)
            AppIcon.check(
              classes: 'copy-icon-button__glyph copy-icon-button__glyph--done',
            ),
          if (!copyState.isCopied) AppIcon.contentCopy(classes: 'copy-icon-button__glyph'),
        ],
      );
    }

    return MonoButton.action(
      label: copyState.isCopied ? hero.copyCtaSuccess : hero.copyCta,
      onPressed: onCopy,
      icon: copyState.isCopied ? AppIcon.check : AppIcon.contentCopy,
      ariaLabel: hero.copyCtaAriaLabel,
    );
  }

  @override
  Component build(BuildContext context) {
    return SiteContentBuilder(
      cubit: _siteContent,
      builder: (context, content) => BlocBuilder<CopyCubit, CopyState>(
        bloc: _copy,
        builder: (context, copyState) => _button(content, copyState),
      ),
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.copy-icon-button', [
      css('&').styles(
        display: .inlineFlex,
        padding: .all(AppSpacing.xxs),
        radius: .all(.circular(AppRadius.base)),
        cursor: .pointer,
        transition: AppMotion.ease('all'),
        justifyContent: .center,
        alignItems: .center,
        color: AppColors.onSurfaceVariant,
        fontSize: 15.px,
      ),
      css('&:hover').styles(
        color: AppColors.tertiary,
        backgroundColor: AppColors.surfaceContainerHigh.alpha(0.6),
      ),
      css('.copy-icon-button__glyph--done').styles(color: AppColors.tertiary),
    ]),
  ];
}
