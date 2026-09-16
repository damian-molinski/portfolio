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

/// Writes an address to the clipboard and confirms it in place for two seconds.
///
/// One of only two components on the site that ship JavaScript. [isIconOnly] is its only parameter
/// and it is a `bool`, because a `@client` component is reconstructed on the client from values the
/// pre-rendered markup carries as attributes — an [AppIcon] or a content object could not make that
/// crossing. For the same reason this takes a single unnamed constructor: Jaspr's hydration codegen
/// calls the unnamed one, so named constructors compile but fail the client build.
///
/// Its copy does not cross the boundary either. An island hydrates as its own component tree and
/// cannot see the [BlocProvider] above `App`, so it resolves [SiteContentCubit] from `get_it`
/// instead. That is safe only because the content is `const`-backed and deterministic: server and
/// client read the same literals and produce the same markup. A runtime content source would break
/// hydration here, and this is the decision that would have to change first.
///
/// The design uses it twice, and the two differ only in whether they show a text label: the hero's
/// carries one and swaps it on success, the contact card's is a bare glyph that becomes a tick. Each
/// gets its own [CopyCubit] from `get_it`, which registers it as a factory — a shared instance would
/// make both confirm on a single click.
@client
class CopyEmailButton extends StatefulComponent {
  const CopyEmailButton({required this.isIconOnly, super.key});

  /// Whether this renders as a bare glyph rather than a labelled button.
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
    // Only the cubit this island owns. [SiteContentCubit] is a lazy singleton shared with the rest
    // of the page.
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
