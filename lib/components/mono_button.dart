import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../utils/markup.dart';
import 'icons.dart';

enum MonoButtonVariant {
  primary,
  ghost;

  String get className => 'mono-button mono-button--$name';
}

class MonoButton extends StatelessComponent {
  const MonoButton.link({
    required this.label,
    required String this.href,
    this.icon,
    this.ariaLabel,
    this.variant = MonoButtonVariant.primary,
    super.key,
  }) : onPressed = null,
       isSubmit = false,
       isDisabled = false;
  const MonoButton.action({
    required this.label,
    required VoidCallback this.onPressed,
    this.icon,
    this.ariaLabel,
    this.variant = MonoButtonVariant.ghost,
    this.isDisabled = false,
    super.key,
  }) : href = null,
       isSubmit = false;
  const MonoButton.submit({
    required this.label,
    this.icon,
    this.ariaLabel,
    this.variant = MonoButtonVariant.primary,
    this.isDisabled = false,
    super.key,
  }) : href = null,
       onPressed = null,
       isSubmit = true;

  final String label;
  final String? href;
  final VoidCallback? onPressed;
  final AppIcon? icon;
  final String? ariaLabel;

  final MonoButtonVariant variant;
  final bool isSubmit;
  final bool isDisabled;

  List<Component> get _content => [
    if (icon case final icon?) icon(classes: 'mono-button__icon'),
    span(classes: 'mono-button__label', [.text(label)]),
  ];

  @override
  Component build(BuildContext context) {
    final semantics = {if (ariaLabel case final ariaLabel?) 'aria-label': ariaLabel};
    final className = classNames([variant.className, if (isSubmit) 'mono-button--block']);

    if (href case final href?) {
      return a(classes: className, href: href, attributes: semantics, _content);
    }

    return button(
      classes: className,
      type: isSubmit ? .submit : .button,
      disabled: isDisabled,
      attributes: semantics,
      events: onPressed == null ? null : events(onClick: onPressed!),
      _content,
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.mono-button', [
      css('&')
          .combine(AppType.labelMd)
          .styles(
            display: .inlineFlex,
            padding: .symmetric(vertical: AppSpacing.xs, horizontal: AppSpacing.md),
            border: AppBorders.hairline(Colors.transparent),
            radius: .all(.circular(AppRadius.lg)),
            cursor: .pointer,
            transition: AppMotion.ease('all'),
            alignItems: .center,
            gap: Gap(column: AppSpacing.xs),
            whiteSpace: .noWrap,
          ),
      css('&:hover').styles(transform: .translate(y: (-2).px)),
      css('&:active').styles(transform: .scale(0.98)),
      css('&:disabled').styles(opacity: 0.55, cursor: .notAllowed, transform: .none),

      css('&.mono-button--block').styles(width: 100.percent, justifyContent: .center),

      css('&.mono-button--primary').styles(
        border: AppBorders.hairline(AppColors.tertiary.alpha(0.4)),
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: 4.px,
          blur: 20.px,
          color: AppColors.primaryContainer.alpha(0.35),
        ),
        color: AppColors.onPrimaryContainer,
        raw: {
          'background-image':
              'linear-gradient(to right, ${AppColors.primaryContainer.value}, ${AppColors.inversePrimary.value})',
        },
      ),
      css('&.mono-button--primary:hover').styles(
        border: AppBorders.hairline(AppColors.tertiary),
        shadow: BoxShadow(offsetX: .zero, offsetY: .zero, blur: 24.px, color: AppColors.tertiary.alpha(0.4)),
        // A multiplier, not a percentage: `brightness(110)` is 110x and renders the button white.
        filter: .brightness(1.1),
      ),

      css('&.mono-button--ghost').styles(
        border: AppBorders.hairline(AppColors.tertiary.alpha(0.3)),
        color: AppColors.onSurface,
        backgroundColor: AppColors.surfaceContainerLow.alpha(0.6),
      ),
      css('&.mono-button--ghost:hover').styles(
        border: AppBorders.hairline(AppColors.tertiary),
        shadow: BoxShadow(offsetX: .zero, offsetY: .zero, blur: 24.px, color: AppColors.tertiary.alpha(0.25)),
        backgroundColor: AppColors.surfaceContainerLow.alpha(0.9),
      ),

      css('.mono-button__icon').styles(
        transition: AppMotion.ease('transform'),
        fontSize: 15.px,
      ),
      css('&:hover .mono-button__icon').styles(transform: .translate(x: 2.px)),
      css('&.mono-button--ghost .mono-button__icon').styles(color: AppColors.secondary),
      css('&.mono-button--ghost:hover .mono-button__icon').styles(color: AppColors.tertiary),
    ]),
  ];
}
