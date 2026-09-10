import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';
import '../content/site_content.dart';
import 'icons.dart';
import 'mono_button.dart';

/// Where the submit button is in its sequence.
enum DispatchStatus {
  idle,
  transmitting,
  sent;

  /// The button is inert while the sequence runs, so a second press cannot start it again.
  bool get blocksSubmit => this != idle;
}

/// The consultation form.
///
/// **This form does not send anything.** Decision D5: the design's `handleSend` was a 900ms
/// `setTimeout` that reported success without a request behind it, and reproducing that would mean
/// telling a visitor their message arrived when nothing received it. The sequence below is the
/// design's, minus the lie — [_dispatch] is a documented no-op, and wiring a real endpoint is
/// explicitly out of scope for this plan.
///
/// Validation runs in Dart as well as through the native `required` attributes, so the message is the
/// same whether or not the browser gets there first.
@client
class ContactForm extends StatefulComponent {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  static const _transmitDuration = Duration(milliseconds: 900);
  static const _confirmationDuration = Duration(seconds: 3);

  final Map<ContactField, String> _values = {for (final field in ContactField.values) field: ''};

  ScopeOption _scope = ScopeOption.values.first;
  DispatchStatus _status = DispatchStatus.idle;
  bool _showValidationError = false;
  Timer? _sequence;

  Iterable<ContactField> get _emptyRequiredFields =>
      ContactField.values.where((field) => field.isRequired && _values[field]!.trim().isEmpty);

  @override
  void dispose() {
    _sequence?.cancel();
    super.dispose();
  }

  /// Where a real submission would go.
  ///
  /// [[TODO: dispatch endpoint]] — until one exists, everything the visitor typed stays in the
  /// browser and is discarded on reset.
  void _dispatch() {}

  void _onSubmit(web.Event event) {
    event.preventDefault();
    if (_status.blocksSubmit) return;

    if (_emptyRequiredFields.isNotEmpty) {
      setState(() => _showValidationError = true);
      return;
    }

    _dispatch();
    setState(() {
      _showValidationError = false;
      _status = DispatchStatus.transmitting;
    });

    _sequence = Timer(_transmitDuration, () {
      if (!mounted) return;
      setState(() {
        _status = DispatchStatus.sent;
        _values.updateAll((_, __) => '');
        _scope = ScopeOption.values.first;
      });

      _sequence = Timer(_confirmationDuration, () {
        if (mounted) setState(() => _status = DispatchStatus.idle);
      });
    });
  }

  String get _submitLabel => switch (_status) {
    DispatchStatus.idle => ContactFormContent.submitLabel,
    DispatchStatus.transmitting => ContactFormContent.submittingLabel,
    DispatchStatus.sent => ContactFormContent.submittedLabel,
  };

  Component _field(ContactField field) {
    return div(classes: 'contact-form__field', [
      label(classes: 'contact-form__label', htmlFor: field.id, [
        span([.text(field.label)]),
        if (field.isRequired)
          span(
            classes: 'contact-form__required',
            attributes: const {'aria-hidden': 'true'},
            [
              .text(ContactFormContent.requiredHint),
            ],
          ),
      ]),
      if (field.isMultiline)
        textarea(
          classes: 'contact-form__control contact-form__control--multiline',
          name: field.name,
          placeholder: field.placeholder,
          required: true,
          rows: 4,
          onInput: (value) => setState(() => _values[field] = value),
          id: field.id,
          attributes: {'aria-required': 'true', 'autocomplete': field.autocomplete},
          [.text(_values[field]!)],
        )
      else
        input(
          classes: 'contact-form__control',
          type: field.isEmail ? .email : .text,
          name: field.name,
          value: _values[field],
          onInput: (value) => setState(() => _values[field] = value as String),
          id: field.id,
          attributes: {
            'placeholder': field.placeholder,
            'required': '',
            'aria-required': 'true',
            'autocomplete': field.autocomplete,
          },
        ),
    ]);
  }

  @override
  Component build(BuildContext context) {
    return form(
      classes: 'contact-form',
      id: ContactFormContent.fieldId,
      events: {'submit': _onSubmit},
      [
        div(classes: 'contact-form__row', [
          _field(ContactField.name),
          _field(ContactField.email),
        ]),

        div(classes: 'contact-form__field', [
          label(classes: 'contact-form__label', htmlFor: ContactFormContent.scopeFieldId, [
            span([.text(ContactFormContent.scopeLabel)]),
          ]),
          select(
            classes: 'contact-form__control',
            name: 'scope',
            value: _scope.value,
            onChange: (selected) => setState(() => _scope = ScopeOption.byValue(selected.first)),
            id: ContactFormContent.scopeFieldId,
            [
              for (final option_ in ScopeOption.values)
                option(value: option_.value, selected: option_ == _scope, [.text(option_.label)]),
            ],
          ),
        ]),

        _field(ContactField.brief),

        // Announced when it appears, so a screen reader hears the rejection rather than only seeing it.
        if (_showValidationError)
          p(
            classes: 'contact-form__error',
            attributes: const {'role': 'alert'},
            [
              .text(ContactFormContent.validationMessage),
            ],
          ),

        MonoButton.submit(
          label: _submitLabel,
          icon: AppIcon.send,
          isDisabled: _status.blocksSubmit,
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.contact-form', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap(row: AppSpacing.md),
      ),
      css('.contact-form__row').styles(
        display: .grid,
        gridTemplate: const GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
        gap: Gap(row: AppSpacing.md, column: AppSpacing.md),
      ),
      css('.contact-form__field').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap(row: AppSpacing.xxs),
      ),

      css('.contact-form__label')
          .combine(AppType.labelSm)
          .styles(
            display: .flex,
            justifyContent: .spaceBetween,
            alignItems: .center,
            color: AppColors.onSurface,
            textTransform: .upperCase,
            letterSpacing: 0.05.em,
          ),
      css('.contact-form__required').styles(
        color: AppColors.tertiary,
        fontSize: 11.px,
        fontWeight: .w400,
      ),

      css('.contact-form__control')
          .combine(AppType.bodyMd)
          .styles(
            width: 100.percent,
            padding: .symmetric(vertical: AppSpacing.xs, horizontal: AppSpacing.sm),
            border: .all(style: .solid, color: AppColors.surfaceContainerHigh, width: 1.px),
            radius: .all(.circular(AppRadius.lg)),
            transition: Transition('all', duration: 200.ms, curve: .easeOut),
            color: AppColors.onSurface,
            backgroundColor: AppColors.surfaceContainerLowest,
          ),
      css('.contact-form__control--multiline').styles(
        minHeight: 7.rem,
        raw: {'resize': 'none'},
      ),
      // The design's `outline/70` measures 3.53:1 on this ground. Full opacity is 6.08:1 and the
      // placeholder still reads as secondary to the value beside it.
      css('.contact-form__control::placeholder').styles(color: AppColors.outline),
      css('.contact-form__control:focus').styles(
        border: .all(style: .solid, color: AppColors.tertiary, width: 1.px),
        outline: const Outline(style: .none),
        shadow: BoxShadow(offsetX: .zero, offsetY: .zero, blur: 16.px, color: AppColors.tertiary.alpha(0.15)),
      ),

      // `:focus` drops the outline for the design's border-and-glow treatment, which would take the
      // ring away from keyboard users too. This puts it back for them alone.
      css('.contact-form__control:focus-visible').styles(
        outline: const Outline(
          color: AppColors.tertiary,
          style: .solid,
          width: OutlineWidth(Unit.pixels(2)),
          offset: Unit.pixels(2),
        ),
      ),

      css('.contact-form__error').combine(AppType.labelMd).styles(color: AppColors.error),
    ]),

    // From 768px the name and email fields share a row.
    css.media(AppBreakpoints.fromMd, [
      css('.contact-form .contact-form__row').styles(
        gridTemplate: const GridTemplate(
          columns: GridTracks([
            GridTrack.repeat(TrackRepeat(2), [GridTrack(TrackSize.fr(1))]),
          ]),
        ),
      ),
    ]),
  ];
}
