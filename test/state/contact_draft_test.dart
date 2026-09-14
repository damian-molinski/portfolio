import 'package:portfolio/content/site_content.dart';
import 'package:portfolio/state/contact_draft.dart';
import 'package:test/test.dart';

extension on ContactDraftBuilder {
  /// Fills every required field with something plausible.
  void fillRequiredFields() {
    name = 'Ada Lovelace';
    email = 'ada@example.com';
    brief = 'A note about the engine.';
  }
}

void main() {
  group(ContactDraftBuilder, () {
    test('starts empty, on the first scope', () {
      final builder = ContactDraftBuilder();

      expect(builder.missingFields, ContactField.values);
      expect(builder.scope, ScopeOption.values.first);
    });

    group('missingFields', () {
      test('lists every required field while the form is untouched', () {
        expect(ContactDraftBuilder().missingFields, ContactField.values);
      });

      test('counts a field holding only whitespace as missing', () {
        final builder = ContactDraftBuilder()
          ..fillRequiredFields()
          ..brief = '   ';

        expect(builder.missingFields, [ContactField.brief]);
      });

      test('is empty once every required field carries something', () {
        final builder = ContactDraftBuilder()..fillRequiredFields();

        expect(builder.missingFields, isEmpty);
      });
    });

    group('isComplete', () {
      test('is false while a required field is blank', () {
        final builder = ContactDraftBuilder()..name = 'Ada Lovelace';

        expect(builder.isComplete, isFalse);
      });

      test('is true once nothing is missing', () {
        final builder = ContactDraftBuilder()..fillRequiredFields();

        expect(builder.isComplete, isTrue);
      });
    });

    group('build', () {
      test('throws rather than returning a half-built draft', () {
        final builder = ContactDraftBuilder()..name = 'Ada Lovelace';

        expect(builder.build, throwsStateError);
      });

      test('trims what it was given', () {
        final builder = ContactDraftBuilder()
          ..name = '  Ada Lovelace  '
          ..email = ' ada@example.com '
          ..brief = ' A note about the engine. '
          ..scope = ScopeOption.values.last;

        final draft = builder.build();

        expect(draft.name, 'Ada Lovelace');
        expect(draft.email, 'ada@example.com');
        expect(draft.brief, 'A note about the engine.');
        expect(draft.scope, ScopeOption.values.last);
      });

      test('defaults an untouched trap to empty rather than null', () {
        final builder = ContactDraftBuilder()..fillRequiredFields();

        final draft = builder.build();

        expect(draft.honeypot, isEmpty);
      });

      test('carries a filled trap through', () {
        final builder = ContactDraftBuilder()
          ..fillRequiredFields()
          ..honeypot = 'Acme Corp';

        final draft = builder.build();

        expect(draft.honeypot, 'Acme Corp');
      });
    });

    group('clear', () {
      test('returns it to the state an untouched form is in', () {
        final builder = ContactDraftBuilder()
          ..fillRequiredFields()
          ..honeypot = 'Acme Corp'
          ..scope = ScopeOption.values.last;

        builder.clear();

        expect(builder.missingFields, ContactField.values);
        expect(builder.honeypot, isNull);
        expect(builder.scope, ScopeOption.values.first);
      });
    });
  });

  group(ContactDraft, () {
    group('toJson', () {
      test('serialises the scope by value and the trap as company', () {
        final builder = ContactDraftBuilder()
          ..fillRequiredFields()
          ..honeypot = 'Acme Corp'
          ..scope = ScopeOption.values.last;
        final draft = builder.build();

        final json = draft.toJson();

        expect(json, {
          'name': 'Ada Lovelace',
          'email': 'ada@example.com',
          'brief': 'A note about the engine.',
          'scope': ScopeOption.values.last.value,
          'company': 'Acme Corp',
        });
      });
    });
  });
}
