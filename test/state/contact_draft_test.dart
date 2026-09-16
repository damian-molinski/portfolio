import 'package:portfolio/content/site_content.dart';
import 'package:portfolio/state/contact_draft.dart';
import 'package:test/test.dart';

extension on ContactDraftBuilder {
  void fillRequiredFields() {
    name = 'Ada Lovelace';
    email = 'ada@example.com';
    brief = 'A note about the engine.';
  }
}

final _everyFieldMissing = {
  for (final field in ContactField.values) field: FieldProblem.missing,
};

void main() {
  group(ContactDraftBuilder, () {
    test('starts empty, on the first scope', () {
      final builder = ContactDraftBuilder();

      expect(builder.problems, _everyFieldMissing);
      expect(builder.scope, ScopeOption.initial);
    });

    group('problems', () {
      test('marks every required field missing while the form is untouched', () {
        expect(ContactDraftBuilder().problems, _everyFieldMissing);
      });

      test('counts a field holding only whitespace as missing', () {
        final builder = ContactDraftBuilder()
          ..fillRequiredFields()
          ..brief = '   ';

        expect(builder.problems, {ContactField.brief: FieldProblem.missing});
      });

      test('is empty once every required field carries something', () {
        final builder = ContactDraftBuilder()..fillRequiredFields();

        expect(builder.problems, isEmpty);
      });

      test('marks an address with no domain malformed rather than missing', () {
        final builder = ContactDraftBuilder()
          ..fillRequiredFields()
          ..email = 'ada';

        expect(builder.problems, {ContactField.email: FieldProblem.malformed});
      });

      test('marks a dotless domain malformed', () {
        final builder = ContactDraftBuilder()
          ..fillRequiredFields()
          ..email = 'ada@localhost';

        expect(builder.problems, {ContactField.email: FieldProblem.malformed});
      });

      test('accepts an address once it has a dotted domain', () {
        final builder = ContactDraftBuilder()
          ..fillRequiredFields()
          ..email = 'ada.lovelace+notes@sub.example.co.uk';

        expect(builder.problems, isEmpty);
      });

      test('reports a blank name and a malformed address together', () {
        final builder = ContactDraftBuilder()
          ..fillRequiredFields()
          ..name = ''
          ..email = 'ada';

        expect(builder.problems, {
          ContactField.name: FieldProblem.missing,
          ContactField.email: FieldProblem.malformed,
        });
      });
    });

    group('isComplete', () {
      test('is false while a required field is blank', () {
        final builder = ContactDraftBuilder()..name = 'Ada Lovelace';

        expect(builder.isComplete, isFalse);
      });

      test('is false while the address is malformed, blank or not', () {
        final builder = ContactDraftBuilder()
          ..fillRequiredFields()
          ..email = 'ada';

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

        expect(builder.problems, _everyFieldMissing);
        expect(builder.honeypot, isNull);
        expect(builder.scope, ScopeOption.initial);
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
