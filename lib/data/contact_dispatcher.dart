import 'dart:convert';

import 'package:http/http.dart' as http;

import '../state/contact_draft.dart';

/// Sends a completed enquiry to the site's own contact endpoint.
abstract interface class ContactDispatcher {
  /// Posts [draft], reporting whether it was accepted.
  ///
  /// Unlike [Clipboard.write], a false here **is** shown to the visitor: a copy that did not happen
  /// leaves the address on screen beside the button, but a message that did not arrive leaves
  /// nothing, so the form says so and keeps what was typed.
  Future<bool> send(ContactDraft draft);
}

/// Posts the draft as JSON to a Cloudflare Pages Function on the site's own origin.
///
/// No [kIsWeb] guard, unlike [BrowserClipboard]: `package:http` resolves `Client()` through a
/// conditional import and works on both halves of the dual compilation, and `send` is only ever
/// reached from a click on the hydrated island — never during pre-rendering.
final class HttpContactDispatcher implements ContactDispatcher {
  const HttpContactDispatcher({
    required final http.Client client,
    required Uri base,
  }) : _client = client,
       _base = base;

  final http.Client _client;
  final Uri _base;

  @override
  Future<bool> send(ContactDraft draft) async {
    final body = jsonEncode(draft.toJson());
    final http.Response response;

    try {
      response = await _client.post(
        _base.resolve('/api/contact'),
        headers: const {'content-type': 'application/json'},
        body: body,
      );
    } on http.ClientException {
      // Offline, a refused connection, or a request that never reached the function. The visitor is
      // told the send failed, which is true, rather than being given the reason.
      return false;
    }

    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
