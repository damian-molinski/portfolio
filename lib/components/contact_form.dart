import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';
import '../content/site_content.dart';
import '../data/site_content_repository.dart';
import '../di/injector.dart';
import '../state/bloc_builder.dart';
import '../state/contact_cubit.dart';
import '../state/contact_draft.dart';
import '../state/contact_state.dart';
import '../state/site_content_cubit.dart';
import '../state/site_content_state.dart';
import 'icons.dart';
import 'mono_button.dart';

/// The consultation form.
///
/// [ContactCubit] owns the draft and the request; this only renders it and reports back what the
/// visitor typed. The one thing here the visitor never sees is the trap input — see [_honeypot].
///
/// Like [CopyEmailButton], this hydrates as its own component tree and so cannot see the
/// [BlocProvider] above `App`. It resolves both cubits from `get_it` instead, and owns the
/// [ContactCubit] it is given — a factory registration, closed in [dispose].
@client
class ContactForm extends StatefulComponent {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  late final SiteContentCubit _siteContent;
  late final ContactCubit _contact;

  @override
  void initState() {
    super.initState();

    _siteContent = getIt<SiteContentCubit>();
    _contact = getIt<ContactCubit>();
  }

  @override
  void dispose() {
    _contact.close();
    super.dispose();
  }

  void _onSubmit(web.Event event) {
    event.preventDefault();
    _contact.submit();
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

  String? _errorMessage(ContactFormContent copy, ContactState formState) {
    final missingNouns = formState.problems.entries
        .where((entry) => entry.value == FieldProblem.missing)
        .map((entry) => entry.key.noun)
        .toList();

    final sentences = [
      if (missingNouns.isNotEmpty) copy.missingMessage(missingNouns),
      if (formState.problems.containsValue(FieldProblem.malformed)) copy.malformedEmailMessage,
      if (formState.failure case final failure?) _failureMessage(copy, failure),
    ];

    return sentences.isEmpty ? null : sentences.join(' ');
  }

  String _controlClasses(FieldProblem? problem, {bool isMultiline = false}) {
    return [
      'contact-form__control',
      if (isMultiline) 'contact-form__control--multiline',
      if (problem != null) 'contact-form__control--invalid',
    ].join(' ');
  }

  /// The control's share of the rejection: it is marked, and it points at the paragraph that says
  /// what is wrong with it, so a screen reader hears the reason on focus rather than only when the
  /// alert first appeared.
  Map<String, String> _problemAttributes(ContactFormContent copy, FieldProblem? problem) {
    if (problem == null) return const {};

    return {'aria-invalid': 'true', 'aria-describedby': copy.errorId};
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
        if (field.isRequired)
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
            ..._problemAttributes(copy, problem),
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
            ..._problemAttributes(copy, problem),
          },
        ),
    ]);
  }

  /// A field no person sees, and no person fills.
  ///
  /// It is uncontrolled — its value is recorded on the draft but never enters [ContactState], so
  /// typing into it re-renders nothing and the text a bot enters stays put. What it catches is the
  /// scraper that fills every input in the rendered HTML and replays it; a bot posting straight to
  /// the endpoint never sees it. That is the limit of it, and the answer if abuse arrives anyway is
  /// a challenge at the edge, not more of this.
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

        // Announced when it appears, so a screen reader hears the rejection rather than only seeing
        // it. One paragraph serves every cause; the message says which, and each marked control
        // points back at it.
        if (_errorMessage(copy, formState) case final message?)
          p(
            classes: 'contact-form__error',
            id: copy.errorId,
            attributes: const {'role': 'alert'},
            [
              .text(message),
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
    return BlocBuilder<SiteContentCubit, SiteContentState>(
      bloc: _siteContent,
      builder: (context, state) => BlocBuilder<ContactCubit, ContactState>(
        bloc: _contact,
        builder: (context, formState) => _form(state.content, formState),
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

      css('.contact-form__select').styles(
        display: .block,
        position: .relative(),
        width: 100.percent,
      ),
      // Room for the chevron, so a long option label cannot run under it.
      css('.contact-form__control--select').styles(
        padding: .only(right: AppSpacing.xl),
        appearance: .none,
      ),
      // Centred by auto margins rather than a translate: the global reduced-motion rule drops every
      // transform, and this one would take the chevron with it.
      css('.contact-form__select-chevron').styles(
        position: .absolute(top: .zero, bottom: .zero, right: AppSpacing.sm),
        margin: .symmetric(vertical: .auto),
        pointerEvents: .none,
        color: AppColors.onSurfaceVariant,
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

      // Both rules, because `.contact-form__control:focus` above is a pseudo-class and outranks a
      // plain class: focusing a field the summary named must not make it look accepted. The second
      // matches that specificity and wins on source order.
      css('.contact-form__control--invalid').styles(
        border: .all(style: .solid, color: AppColors.error, width: 1.px),
      ),
      css('.contact-form__control--invalid:focus').styles(
        border: .all(style: .solid, color: AppColors.error, width: 1.px),
        shadow: BoxShadow(offsetX: .zero, offsetY: .zero, blur: 16.px, color: AppColors.error.alpha(0.15)),
      ),

      css('.contact-form__error').combine(AppType.labelMd).styles(color: AppColors.error),

      // Off-screen rather than `display: none`: a bot worth catching skips inputs it can tell are
      // hidden, and this one is only worth having if it gets filled.
      css('.contact-form__honeypot').styles(
        position: .absolute(left: (-9999).px),
        width: 1.px,
        height: 1.px,
        overflow: .hidden,
      ),
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
