import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../utils/markup.dart';
import 'icons.dart';

/// The two button treatments in the design.
enum MonoButtonVariant {
  /// Solid blue gradient. One per view — the hero's inquiry call to action and the form's submit.
  primary,

  /// Glass fill with a cyan hairline. Everything else.
  ghost;

  String get className => 'mono-button mono-button--$name';
}

/// A monospaced action in the design's `[ label() ]` form.
///
/// Three constructors rather than one with a nullable callback, because the element has to differ:
/// [MonoButton.link] renders an `<a>`, [MonoButton.action] and [MonoButton.submit] render `<button>`.
/// A single component taking an optional `onPressed` would compile a handler into the pre-rendered
/// page that nothing can ever fire — the static build has no client to attach it to unless the caller
/// is inside a `@client` boundary.
class MonoButton extends StatelessComponent {
  /// A navigation action. Renders an `<a href>`, so it works without JavaScript.
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

  /// An in-page action. Only meaningful inside a `@client` component — nothing hydrates the handler
  /// otherwise.
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

  /// A form's submit control.
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

  /// Overrides the accessible name when [label] alone does not say where the action goes.
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

      // The design's submit fills its panel and centres its content
      // (`docs/reference/landing-page.html:584`); every other button is shrink-to-fit.
      css('&.mono-button--block').styles(width: 100.percent, justifyContent: .center),

      css('&.mono-button--primary').styles(
        border: AppBorders.hairline(AppColors.tertiary.alpha(0.4)),
        shadow: BoxShadow(
          offsetX: .zero,
          offsetY: 4.px,
          blur: 20.px,
          color: AppColors.primaryContainer.alpha(0.35),
        ),
        // `on-primary-container`, not `on-primary`: the fill is the primary *container* gradient, and
        // the design's darker pairing measured 2.71:1 against it. See amendment A9.
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
