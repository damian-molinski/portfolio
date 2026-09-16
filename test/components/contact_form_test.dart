import 'package:jaspr_test/server_test.dart';
import 'package:portfolio/components/contact_form.dart';
import 'package:portfolio/content/site_content.dart';
import 'package:portfolio/data/contact_dispatcher.dart';
import 'package:portfolio/di/injector.dart';
import 'package:portfolio/state/contact_cubit.dart';
import 'package:portfolio/state/contact_draft.dart';
import 'package:portfolio/state/contact_state.dart';

import 'render.dart';

/// Accepts whatever it is handed. The real dispatcher would post to `Uri.base`, which is a `file:`
/// URI on the VM.
final class _AcceptingDispatcher implements ContactDispatcher {
  @override
  Future<DispatchFailure?> send(ContactDraft draft) async => null;
}

/// These assert the **pre-rendered** markup, which is what a visitor gets before — and without —
/// hydration, and what every accessibility affordance on the form is carried by.
///
/// They cannot assert a re-render: `BlocBuilder` hands `StreamBuilder` a null stream off the web
/// (`kIsWeb` is a compile-time constant, false on the VM), so the tree renders once from the state
/// the cubit is already in. That is why the blocked case drives [ContactCubit] *before* rendering.
/// The sequencing itself is covered in `test/state/contact_cubit_test.dart`.
void main() {
  const copy = ContactFormContent();

  late ContactCubit contact;

  setUp(() {
    configureDependencies();

    getIt.unregister<ContactDispatcher>();
    getIt.registerSingleton<ContactDispatcher>(_AcceptingDispatcher());

    // The form resolves its own cubit from `get_it`, which registers a factory — so re-registering
    // one instance as a singleton is the only way for a test to hold what the form will render.
    contact = getIt<ContactCubit>();
    getIt.unregister<ContactCubit>();
    getIt.registerSingleton<ContactCubit>(contact);
  });

  tearDown(getIt.reset);

  group(ContactForm, () {
    testServer('renders a control per field, labelled and wired to it', (tester) async {
      final rendered = await tester.render(const ContactForm());

      for (final field in ContactField.values) {
        final control = rendered.querySelector('#${field.id}');
        final fieldLabel = rendered.querySelector('label[for="${field.id}"]');

        expect(control, isNotNull);
        expect(fieldLabel, isNotNull);
        expect(fieldLabel!.text, contains(field.label));
        expect(control!.attributes, containsPair('autocomplete', field.autocomplete));
      }
    });

    testServer('keeps the browser out of validation, but not out of the semantics', (tester) async {
      final rendered = await tester.render(const ContactForm());
      final form = rendered.querySelector('form')!;

      // Native constraint validation runs before the `submit` event and cancels it, which would
      // disable every message the form renders. The semantics stay; the browser's own UI does not.
      expect(form.attributes, contains('novalidate'));
      expect(rendered.querySelector('#${ContactField.email.id}')!.attributes, containsPair('type', 'email'));
      for (final field in ContactField.values) {
        expect(rendered.querySelector('#${field.id}')!.attributes, containsPair('aria-required', 'true'));
      }
    });

    testServer('ships the trap off-screen, and says nothing about it', (tester) async {
      final rendered = await tester.render(const ContactForm());
      final trap = rendered.querySelector('#${copy.honeypotFieldId}')!;

      expect(trap.attributes, containsPair('name', copy.honeypotName));
      expect(trap.attributes, containsPair('tabindex', '-1'));
      // Off-screen rather than hidden — a bot worth catching skips inputs it can tell are hidden.
      expect(rendered.querySelector('.contact-form__honeypot'), isNotNull);
    });

    testServer('points a blocked control at the line beneath it', (tester) async {
      await contact.submit();

      final rendered = await tester.render(const ContactForm());

      for (final field in ContactField.values) {
        final control = rendered.querySelector('#${field.id}')!;

        expect(control.classes, contains('contact-form__control--invalid'));
        expect(control.attributes, containsPair('aria-invalid', 'true'));
        // Its own paragraph, not a shared one: a screen reader must not read another field's
        // problem as this one's.
        expect(control.attributes, containsPair('aria-describedby', field.errorId));
        expect(rendered.querySelector('#${field.errorId}'), isNotNull);
      }
    });

    testServer('marks nothing invalid on an untouched form', (tester) async {
      final rendered = await tester.render(const ContactForm());

      expect(rendered.querySelectorAll('[aria-invalid]'), isEmpty);
      expect(rendered.querySelectorAll('.contact-form__control--invalid'), isEmpty);
    });

    testServer('reports no problem beside the message that says it sent', (tester) async {
      // The regression: a blocked press turns validation on, and a later success empties the draft.
      await contact.submit();
      contact.updateName('Ada Lovelace');
      contact.updateEmail('ada@example.com');
      contact.updateBrief('A note about the engine.');
      await contact.submit();

      final rendered = await tester.render(const ContactForm());

      expect(rendered.querySelector('button')!.text, contains(copy.submittedLabel));
      expect(rendered.querySelectorAll('.contact-form__error'), isEmpty);
    });
  });
}
