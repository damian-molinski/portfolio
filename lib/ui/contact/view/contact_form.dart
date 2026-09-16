import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../../../di/injector.dart';
import '../../../domain/models/contact_draft.dart';
import '../../../domain/models/site_content.dart';
import '../../../utils/iterable_extensions.dart';
import '../../../utils/markup.dart';
import '../../core/binding/bloc_builder.dart';
import '../../core/components/icons.dart';
import '../../core/components/mono_button.dart';
import '../../core/theme.dart';
import '../../core/view_model/site_content_builder.dart';
import '../../core/view_model/site_content_view_model.dart';
import '../view_model/contact_state.dart';
import '../view_model/contact_view_model.dart';

@client
class ContactForm extends StatefulComponent {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  late final SiteContentViewModel _siteContent;
  late final ContactViewModel _contact;

  @override
  void initState() {
    super.initState();

    _siteContent = getIt<SiteContentViewModel>();
    _contact = getIt<ContactViewModel>();
  }

  @override
  void dispose() {
    _contact.close();
    super.dispose();
  }

  Future<void> _onSubmit(web.Event event) async {
    event.preventDefault();
    await _contact.submit();

    if (_contact.state.status == DispatchStatus.sent) {
      _clearMultilineControls();
      return;
    }

    _focusFirstProblem();
  }

  void _clearMultilineControls() {
    final multilineFields = ContactField.values.where((field) => field.isMultiline);

    for (final field in multilineFields) {
      final control = web.document.getElementById(field.id) as web.HTMLTextAreaElement?;
      control?.value = '';
    }
  }

  void _focusFirstProblem() {
    final blocked = _contact.state.problems.keys.firstOrNull;
    if (blocked == null) return;

    (web.document.getElementById(blocked.id) as web.HTMLElement?)?.focus();
  }

  String _submitLabel(ContactFormContent copy, DispatchStatus status) => switch (status) {
    DispatchStatus.idle => copy.submitLabel,
    DispatchStatus.transmitting => copy.submittingLabel,
    DispatchStatus.sent => copy.submittedLabel,
    DispatchStatus.failed => copy.submitLabel,
  };

  String _failureMessage(ContactFormContent copy, DispatchFailure failure) => switch (failure) {
    DispatchFailure.network => copy.networkFailureMessage,
    DispatchFailure.rejected => copy.rejectedFailureMessage,
    DispatchFailure.rateLimited => copy.rateLimitedFailureMessage,
    DispatchFailure.mailer => copy.mailerFailureMessage,
  };

  String _fieldMessage(ContactFormContent copy, ContactField field, FieldProblem problem) => switch (problem) {
    FieldProblem.missing => copy.missingMessage(field.noun),
    FieldProblem.malformed => copy.malformedEmailMessage,
  };

  String _controlClasses(FieldProblem? problem, {bool isMultiline = false}) {
    return classNames([
      'contact-form__control',
      if (isMultiline) 'contact-form__control--multiline',
      if (problem != null) 'contact-form__control--invalid',
    ]);
  }

  Map<String, String> _problemAttributes(ContactField field, FieldProblem? problem) {
    if (problem == null) return const {};

    return {'aria-invalid': 'true', 'aria-describedby': field.errorId};
  }

  Component _field(
    ContactField field,
    ContactFormContent copy, {
    required String? value,
    required FieldProblem? problem,
    required ValueChanged<String> onChanged,
  }) {
    final current = value ?? '';

    return div(classes: 'contact-form__field', [
      label(classes: 'contact-form__label', htmlFor: field.id, [
        span([.text(field.label)]),
        span(
          classes: 'contact-form__required',
          attributes: const {'aria-hidden': 'true'},
          [
            .text(copy.requiredHint),
          ],
        ),
      ]),
      if (field.isMultiline)
        textarea(
          classes: _controlClasses(problem, isMultiline: true),
          name: field.name,
          placeholder: field.placeholder,
          required: true,
          rows: 4,
          onInput: onChanged,
          id: field.id,
          attributes: {
            'aria-required': 'true',
            'autocomplete': field.autocomplete,
            ..._problemAttributes(field, problem),
          },
          [.text(current)],
        )
      else
        input(
          classes: _controlClasses(problem),
          type: field.isEmail ? .email : .text,
          name: field.name,
          value: current,
          onInput: (updated) => onChanged(updated as String),
          id: field.id,
          attributes: {
            'placeholder': field.placeholder,
            'required': '',
            'aria-required': 'true',
            'autocomplete': field.autocomplete,
            ..._problemAttributes(field, problem),
          },
        ),
      // Deliberately not a live region: three of these at once would be read as three
      // interruptions. `_focusFirstProblem` is what announces them, one at a time.
      if (problem case final problem?)
        p(classes: 'contact-form__error', id: field.errorId, [
          .text(_fieldMessage(copy, field, problem)),
        ]),
    ]);
  }

  Component _honeypot(ContactFormContent copy) {
    return div(
      classes: 'contact-form__honeypot',
      attributes: const {'aria-hidden': 'true'},
      [
        input(
          type: .text,
          name: copy.honeypotName,
          onInput: (updated) => _contact.updateHoneypot(updated as String),
          id: copy.honeypotFieldId,
          attributes: const {'tabindex': '-1', 'autocomplete': 'off'},
        ),
      ],
    );
  }

  Component _form(SiteContent content, ContactState formState) {
    final copy = content.contactForm;

    return form(
      classes: 'contact-form',
      id: copy.fieldId,
      noValidate: true,
      events: {'submit': _onSubmit},
      [
        div(classes: 'contact-form__row', [
          _field(
            ContactField.name,
            copy,
            value: formState.name,
            problem: formState.problems[ContactField.name],
            onChanged: _contact.updateName,
          ),
          _field(
            ContactField.email,
            copy,
            value: formState.email,
            problem: formState.problems[ContactField.email],
            onChanged: _contact.updateEmail,
          ),
        ]),

        div(classes: 'contact-form__field', [
          label(classes: 'contact-form__label', htmlFor: copy.scopeFieldId, [
            span([.text(copy.scopeLabel)]),
          ]),
          // The native arrow is drawn against the border regardless of `padding-right`, so the
          // control drops its platform appearance and this wrapper places the chevron itself.
          div(classes: 'contact-form__select', [
            select(
              classes: 'contact-form__control contact-form__control--select',
              name: 'scope',
              value: formState.scope.value,
              onChange: (selected) => _contact.updateScope(ScopeOption.byValue(selected.first)),
              id: copy.scopeFieldId,
              [
                for (final option_ in content.scopeOptions)
                  option(
                    value: option_.value,
                    selected: option_ == formState.scope,
                    [.text(option_.label)],
                  ),
              ],
            ),
            AppIcon.expandMore(classes: 'contact-form__select-chevron'),
          ]),
        ]),

        _field(
          ContactField.brief,
          copy,
          value: formState.brief,
          problem: formState.problems[ContactField.brief],
          onChanged: _contact.updateBrief,
        ),

        _honeypot(copy),

        // A failed send is no field's fault, so it sits beside the button. Nothing focuses it, so
        // `role="alert"` is the only way it is heard.
        if (formState.failure case final failure?)
          p(
            classes: 'contact-form__error',
            attributes: const {'role': 'alert'},
            [
              .text(_failureMessage(copy, failure)),
            ],
          ),

        MonoButton.submit(
          label: _submitLabel(copy, formState.status),
          icon: AppIcon.send,
          isDisabled: formState.status.blocksSubmit,
        ),
      ],
    );
  }

  @override
  Component build(BuildContext context) {
    return SiteContentBuilder(
      cubit: _siteContent,
      builder: (context, content) => BlocBuilder<ContactViewModel, ContactState>(
        bloc: _contact,
        builder: (context, formState) => _form(content, formState),
      ),
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
        gridTemplate: AppGrid.singleColumn,
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
            border: AppBorders.hairline(AppColors.surfaceContainerHigh),
            radius: .all(.circular(AppRadius.lg)),
            transition: AppMotion.ease('all'),
            color: AppColors.onSurface,
            backgroundColor: AppColors.surfaceContainerLowest,
          ),
      css('.contact-form__control--multiline').styles(
        minHeight: 7.rem,
        raw: {'resize': 'none'},
      ),

      css('.contact-form__select').styles(
        display: .block,
        position: .relative(),
        width: 100.percent,
      ),
      css('.contact-form__control--select').styles(
        padding: .only(right: AppSpacing.xl),
        appearance: .none,
      ),
      css('.contact-form__select-chevron').styles(
        position: .absolute(top: .zero, bottom: .zero, right: AppSpacing.sm),
        margin: .symmetric(vertical: .auto),
        pointerEvents: .none,
        color: AppColors.onSurfaceVariant,
      ),
      css('.contact-form__control::placeholder').styles(color: AppColors.outline),
      css('.contact-form__control:focus').styles(
        border: AppBorders.hairline(AppColors.tertiary),
        outline: const Outline(style: .none),
        shadow: BoxShadow(offsetX: .zero, offsetY: .zero, blur: 16.px, color: AppColors.tertiary.alpha(0.15)),
      ),

      // `:focus` above drops the outline for the border-and-glow treatment, which would take the
      // ring away from keyboard users too. This puts it back for them alone.
      css('.contact-form__control:focus-visible').styles(
        outline: AppFocus.ring,
      ),

      // Both rules: `:focus` is a pseudo-class and outranks a plain class, so a blocked field must
      // not look accepted on focus. The second matches that specificity and wins on source order.
      css('.contact-form__control--invalid').styles(
        border: AppBorders.hairline(AppColors.error),
      ),
      css('.contact-form__control--invalid:focus').styles(
        border: AppBorders.hairline(AppColors.error),
        shadow: BoxShadow(offsetX: .zero, offsetY: .zero, blur: 16.px, color: AppColors.error.alpha(0.15)),
      ),

      css('.contact-form__error').combine(AppType.labelMd).styles(color: AppColors.error),

      // Off-screen rather than `display: none` — a bot worth catching skips inputs it can tell are
      // hidden.
      css('.contact-form__honeypot').styles(
        position: .absolute(left: (-9999).px),
        width: 1.px,
        height: 1.px,
        overflow: .hidden,
      ),
    ]),

    css.media(AppBreakpoints.fromMd, [
      css('.contact-form .contact-form__row').styles(
        gridTemplate: AppGrid.twoColumns,
      ),
    ]),
  ];
}
