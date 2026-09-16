import 'package:portfolio/data/dto/contact_draft_dto.dart';
import 'package:portfolio/domain/models/contact_draft.dart';
import 'package:portfolio/domain/models/site_content.dart';
import 'package:test/test.dart';

const _draft = ContactDraft(
  name: 'Ada Lovelace',
  email: 'ada@example.com',
  brief: 'A note about the engine.',
  scope: ScopeOption.other,
  honeypot: '',
);

void main() {
  group(ContactDraftDto, () {
    group('toJson', () {
      test('serialises the scope by value and the trap as company', () {
        final draft = ContactDraft(
          name: _draft.name,
          email: _draft.email,
          brief: _draft.brief,
          scope: ScopeOption.values.last,
          honeypot: 'Acme Corp',
        );

        final json = draft.toDto().toJson();

        expect(json, {
          'name': 'Ada Lovelace',
          'email': 'ada@example.com',
          'brief': 'A note about the engine.',
          'scope': ScopeOption.values.last.value,
          'company': 'Acme Corp',
        });
      });

      test('carries company as an empty string when the trap is untouched', () {
        final json = _draft.toDto().toJson();

        // `isWellFormed` in functions/api/contact.ts requires the key; omitting it is a 400.
        expect(json, containsPair('company', ''));
        expect(json.keys, hasLength(5));
      });
    });
  });
}
