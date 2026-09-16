import 'package:jaspr_test/server_test.dart';
import 'package:portfolio/components/contact_form.dart';
import 'package:portfolio/content/site_content.dart';
import 'package:portfolio/data/contact_dispatcher.dart';
import 'package:portfolio/data/dispatch_outcome.dart';
import 'package:portfolio/di/injector.dart';
import 'package:portfolio/state/contact_cubit.dart';
import 'package:portfolio/state/contact_draft.dart';
import 'package:portfolio/utils/result.dart';

import 'render.dart';

final class _AcceptingDispatcher implements ContactDispatcher {
  @override
  Future<DispatchOutcome> send(ContactDraft draft) async => const Success(DispatchReceipt(204));
}

void main() {
  const copy = ContactFormContent();

  late ContactCubit contact;

  setUp(() {
    configureDependencies();

    getIt.unregister<ContactDispatcher>();
    getIt.registerSingleton<ContactDispatcher>(_AcceptingDispatcher());

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
      expect(rendered.querySelector('.contact-form__honeypot'), isNotNull);
    });

    testServer('points a blocked control at the line beneath it', (tester) async {
      await contact.submit();

      final rendered = await tester.render(const ContactForm());

      for (final field in ContactField.values) {
        final control = rendered.querySelector('#${field.id}')!;

        expect(control.classes, contains('contact-form__control--invalid'));
        expect(control.attributes, containsPair('aria-invalid', 'true'));
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
