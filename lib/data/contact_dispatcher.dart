import 'dart:async';

import 'package:http/http.dart' as http;

import '../state/contact_draft.dart';
import '../utils/json_extensions.dart';
import '../utils/result.dart';
import 'contact_draft_dto.dart';
import 'dispatch_outcome.dart';

abstract interface class ContactDispatcher {
  /// Posts [draft], answering with the receipt the endpoint accepted it under, or the reason it did
  /// not arrive.
  Future<DispatchOutcome> send(ContactDraft draft);
}

final class HttpContactDispatcher implements ContactDispatcher {
  const HttpContactDispatcher({
    required this._client,
    required this._base,
    this._timeout = const Duration(seconds: 20),
  });

  final http.Client _client;
  final Uri _base;
  final Duration _timeout;

  @override
  Future<DispatchOutcome> send(ContactDraft draft) {
    final payload = draft.toDto();
    final body = payload.toJson().encodeJson();

    return _client
        .post(
          _base.resolve('/api/contact'),
          headers: const {'content-type': 'application/json'},
          body: body,
        )
        .timeout(_timeout)
        .then((response) => _outcomeFor(response.statusCode))
        .onError<http.ClientException>((_, _) => const Failure(NetworkDispatchException()))
        .onError<TimeoutException>((_, _) => const Failure(NetworkDispatchException()));
  }

  DispatchOutcome _outcomeFor(int statusCode) => switch (statusCode) {
    >= 200 && < 300 => Success(DispatchReceipt(statusCode)),
    400 => const Failure(RejectedDispatchException()),
    429 => const Failure(RateLimitedDispatchException()),
    // Also a 404, which means the function is not deployed — as far outside the visitor's control
    // as Resend being down.
    _ => const Failure(MailerDispatchException()),
  };
}
