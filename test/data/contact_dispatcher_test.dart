import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:portfolio/content/site_content.dart';
import 'package:portfolio/data/contact_dispatcher.dart';
import 'package:portfolio/data/contact_draft_dto.dart';
import 'package:portfolio/data/dispatch_outcome.dart';
import 'package:portfolio/state/contact_draft.dart';
import 'package:portfolio/utils/result.dart';
import 'package:test/test.dart';

final _base = Uri.parse('https://damian-molinski.dev/');

const _draft = ContactDraft(
  name: 'Ada Lovelace',
  email: 'ada@example.com',
  brief: 'A note about the engine.',
  scope: ScopeOption.audit,
  honeypot: '',
);

HttpContactDispatcher _answering(int statusCode) {
  final client = MockClient((_) async => http.Response('', statusCode));

  return HttpContactDispatcher(client: client, base: _base);
}

Matcher _failsWith<E extends Exception>() =>
    isA<Failure<DispatchReceipt, Exception>>().having((failure) => failure.error, 'error', isA<E>());

void main() {
  group(HttpContactDispatcher, () {
    group('send', () {
      test('posts the draft as JSON to the endpoint on the site origin', () async {
        final requests = <http.Request>[];
        final client = MockClient((request) async {
          requests.add(request);
          return http.Response('', 204);
        });

        await HttpContactDispatcher(client: client, base: _base).send(_draft);

        final request = requests.single;
        expect(request.url, Uri.parse('https://damian-molinski.dev/api/contact'));
        expect(request.headers, containsPair('content-type', 'application/json'));
        expect(jsonDecode(request.body), _draft.toDto().toJson());
      });

      test('receipts the status when the endpoint accepts it', () async {
        expect(await _answering(204).send(_draft), const Success<DispatchReceipt, Exception>(DispatchReceipt(204)));
      });

      test('reads any 2xx as accepted, not only the 204 the function sends', () async {
        expect(await _answering(200).send(_draft), const Success<DispatchReceipt, Exception>(DispatchReceipt(200)));
      });

      test('reads a 400 as the endpoint refusing what was typed', () async {
        expect(await _answering(400).send(_draft), _failsWith<RejectedDispatchException>());
      });

      test('reads a 429 as a rate limit', () async {
        expect(await _answering(429).send(_draft), _failsWith<RateLimitedDispatchException>());
      });

      test('reads a 502 as delivery being down', () async {
        expect(await _answering(502).send(_draft), _failsWith<MailerDispatchException>());
      });

      test('reads the 503 a project missing its secrets answers as delivery being down', () async {
        expect(await _answering(503).send(_draft), _failsWith<MailerDispatchException>());
      });

      test('falls back to delivery being down for anything else', () async {
        expect(await _answering(404).send(_draft), _failsWith<MailerDispatchException>());
        expect(await _answering(500).send(_draft), _failsWith<MailerDispatchException>());
      });

      test('reads a request that never left as a lost connection', () async {
        final client = MockClient((_) async => throw http.ClientException('offline'));
        final dispatcher = HttpContactDispatcher(client: client, base: _base);

        expect(await dispatcher.send(_draft), _failsWith<NetworkDispatchException>());
      });

      test('gives up on a silent endpoint rather than leaving the button transmitting', () async {
        final client = MockClient((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return http.Response('', 204);
        });
        final dispatcher = HttpContactDispatcher(
          client: client,
          base: _base,
          timeout: const Duration(milliseconds: 1),
        );

        expect(await dispatcher.send(_draft), _failsWith<NetworkDispatchException>());
      });
    });
  });
}
