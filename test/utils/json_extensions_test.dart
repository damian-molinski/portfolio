import 'dart:convert';

import 'package:portfolio/data/dto/contact_draft_dto.dart';
import 'package:portfolio/domain/models/contact_draft.dart';
import 'package:portfolio/domain/models/site_content.dart';
import 'package:portfolio/utils/json_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('JsonMapExtension', () {
    group('encodeJson', () {
      test('encodes an empty map as an empty object', () {
        expect(const <String, Object?>{}.encodeJson(), '{}');
      });

      test('encodes strings, numbers, booleans and null', () {
        final json = {'name': 'Ada', 'count': 2, 'sent': true, 'failure': null}.encodeJson();

        expect(json, '{"name":"Ada","count":2,"sent":true,"failure":null}');
      });

      test('keeps insertion order, as a JSON object does', () {
        expect({'b': 1, 'a': 2}.encodeJson(), '{"b":1,"a":2}');
      });

      test('escapes quotes and newlines rather than dropping them', () {
        final json = {'brief': 'She said "hello".\nThen left.'}.encodeJson();

        expect(jsonDecode(json), {'brief': 'She said "hello".\nThen left.'});
      });

      test('encodes nested maps and lists', () {
        expect(
          {
            'to': ['ada@example.com'],
            'meta': {'scope': 'other'},
          }.encodeJson(),
          '{"to":["ada@example.com"],"meta":{"scope":"other"}}',
        );
      });

      test('is available on a Map<String, String>', () {
        expect(const {'scope': 'other'}.encodeJson(), '{"scope":"other"}');
      });

      test('throws on a value with no JSON form', () {
        expect(
          () => {'client': Object()}.encodeJson(),
          throwsA(isA<JsonUnsupportedObjectError>()),
        );
      });

      test('round-trips the contact payload the endpoint is sent', () {
        const draft = ContactDraft(
          name: 'Ada Lovelace',
          email: 'ada@example.com',
          brief: 'A note about the engine.',
          scope: ScopeOption.other,
          honeypot: '',
        );

        final body = draft.toDto().toJson().encodeJson();

        expect(jsonDecode(body), draft.toDto().toJson());
      });
    });
  });
}
