import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart';

import '../constants/theme.dart';
import 'icons.dart';
import 'mono_button.dart';

/// Writes an address to the clipboard and confirms it in place for two seconds.
///
/// One of only two components on the site that ship JavaScript. Every parameter is a `String` so the
/// component stays serialisable across the hydration boundary — the pre-rendered markup carries these
/// values as attributes, and the client rebuilds from them. For the same reason this takes a single
/// unnamed constructor: Jaspr's hydration codegen reconstructs a `@client` component by calling its
/// unnamed constructor, so named constructors compile but fail the client build.
///
/// The design uses it twice, and the two differ only in whether they show a text label: the hero's
/// carries one and swaps it on success, the contact card's is a bare glyph that becomes a tick.
///
/// The clipboard call sits behind `kIsWeb`. `package:universal_web` stubs the same API on the VM and
/// throws if it is reached, so pre-rendering must not get that far — and the button pre-renders in
/// its idle state regardless, which is also the state a visitor without JavaScript keeps.
@client
class CopyEmailButton extends StatefulComponent {
  const CopyEmailButton({
    required this.email,
    required this.successLabel,
    required this.ariaLabel,
    this.label,
    super.key,
  });

  /// What gets written to the clipboard.
  final String email;

  /// Replaces [label] for two seconds after a successful write.
  final String successLabel;

  final String ariaLabel;

  /// The resting label. Null renders the icon-only variant.
  final String? label;

  /// Whether this renders as a bare glyph rather than a labelled button.
  bool get isIconOnly => label == null;

  @override
  State<CopyEmailButton> createState() => CopyEmailButtonState();
}

class CopyEmailButtonState extends State<CopyEmailButton> {
  static const _confirmationDuration = Duration(seconds: 2);

  bool _copied = false;
  Timer? _revert;

  @override
  void dispose() {
    _revert?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    if (!kIsWeb) return;

    try {
      await window.navigator.clipboard.writeText(component.email).toDart;
    } catch (_) {
      // A denied permission or an insecure origin. Say nothing rather than claim a copy that did not
      // happen — the address is on screen beside the button either way.
      return;
    }

    if (!mounted) return;
    setState(() => _copied = true);
    _revert?.cancel();
    _revert = Timer(_confirmationDuration, () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Component build(BuildContext context) {
    if (component.isIconOnly) {
      return button(
        classes: 'copy-icon-button',
        type: .button,
        attributes: {'aria-label': component.ariaLabel},
        events: events(onClick: _copy),
        [
          if (_copied)
            AppIcon.check(
              classes: 'copy-icon-button__glyph copy-icon-button__glyph--done',
            ),
          if (!_copied) AppIcon.contentCopy(classes: 'copy-icon-button__glyph'),
        ],
      );
    }

    return MonoButton.action(
      label: _copied ? component.successLabel : component.label!,
      onPressed: _copy,
      icon: _copied ? AppIcon.check : AppIcon.contentCopy,
      ariaLabel: component.ariaLabel,
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
        transition: Transition('all', duration: 200.ms, curve: .easeOut),
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
