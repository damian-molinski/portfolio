import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';
import '../content/site_content.dart';
import '../data/site_content_repository.dart';
import '../di/injector.dart';
import '../state/bloc_builder.dart';
import '../state/contact_cubit.dart';
import '../state/contact_state.dart';
import '../state/site_content_cubit.dart';
import '../state/site_content_state.dart';
import 'icons.dart';
import 'mono_button.dart';

/// The consultation form.
///
/// **This form does not send anything.** [ContactCubit] holds the sequence and says why; nothing
/// here reports a delivery that did not happen.
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
    // Only the cubit this island owns. [SiteContentCubit] is a lazy singleton shared with the page.
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
  };

  Component _field(ContactField field, ContactFormContent copy, ContactState formState) {
    final value = formState.values[field]!;

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
          classes: 'contact-form__control contact-form__control--multiline',
          name: field.name,
          placeholder: field.placeholder,
          required: true,
          rows: 4,
          onInput: (updated) => _contact.updateField(field, updated),
          id: field.id,
          attributes: {'aria-required': 'true', 'autocomplete': field.autocomplete},
          [.text(value)],
        )
      else
        input(
          classes: 'contact-form__control',
          type: field.isEmail ? .email : .text,
          name: field.name,
          value: value,
          onInput: (updated) => _contact.updateField(field, updated as String),
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

  Component _form(SiteContent content, ContactState formState) {
    final copy = content.contactForm;

    return form(
      classes: 'contact-form',
      id: copy.fieldId,
      events: {'submit': _onSubmit},
      [
        div(classes: 'contact-form__row', [
          _field(ContactField.name, copy, formState),
          _field(ContactField.email, copy, formState),
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

        _field(ContactField.brief, copy, formState),

        // Announced when it appears, so a screen reader hears the rejection rather than only seeing it.
        if (formState.showValidationError)
          p(
            classes: 'contact-form__error',
            attributes: const {'role': 'alert'},
            [
              .text(copy.validationMessage),
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
