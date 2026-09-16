import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../state/contact_draft.dart';
import '../state/contact_state.dart';

abstract interface class ContactDispatcher {
  /// Posts [draft], answering with the reason it did not arrive — or null when it did.
  Future<DispatchFailure?> send(ContactDraft draft);
}

final class HttpContactDispatcher implements ContactDispatcher {
  const HttpContactDispatcher({
    required http.Client client,
    required Uri base,
    Duration timeout = const Duration(seconds: 20),
  }) : _client = client,
       _base = base,
       _timeout = timeout;

  final http.Client _client;
  final Uri _base;
  final Duration _timeout;

  @override
  Future<DispatchFailure?> send(ContactDraft draft) async {
    final body = jsonEncode(draft.toJson());
    final http.Response response;

    try {
      response = await _client
          .post(
            _base.resolve('/api/contact'),
            headers: const {'content-type': 'application/json'},
            body: body,
          )
          .timeout(_timeout);
    } on http.ClientException {
      return DispatchFailure.network;
    } on TimeoutException {
      return DispatchFailure.network;
    }

    return _failureFor(response.statusCode);
  }

  DispatchFailure? _failureFor(int statusCode) => switch (statusCode) {
    >= 200 && < 300 => null,
    400 => DispatchFailure.rejected,
    429 => DispatchFailure.rateLimited,
    // Also a 404, which means the function is not deployed — as far outside the visitor's control
    // as Resend being down.
    _ => DispatchFailure.mailer,
  };
}
