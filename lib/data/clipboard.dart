import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart';

abstract interface class Clipboard {
  /// Writes [text], reporting whether it actually happened.
  Future<bool> write(String text);
}

final class BrowserClipboard implements Clipboard {
  const BrowserClipboard();

  @override
  Future<bool> write(String text) async {
    if (!kIsWeb) return false;

    try {
      await window.navigator.clipboard.writeText(text).toDart;
    } catch (_) {
      // A denied permission or an insecure origin. Say nothing — the address is on screen anyway.
      return false;
    }

    return true;
  }
}
