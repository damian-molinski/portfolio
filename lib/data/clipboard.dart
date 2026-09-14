import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart';

/// Writes text to the system clipboard.
abstract interface class Clipboard {
  /// Writes [text], reporting whether it actually happened.
  ///
  /// A false result is not an error to show anyone — see [BrowserClipboard.write].
  Future<bool> write(String text);
}

/// The browser's clipboard, behind [kIsWeb].
///
/// `package:universal_web` stubs the same API on the VM and throws if it is reached, so
/// pre-rendering must not get that far; on the server this reports a write that did not happen and
/// leaves the button in its idle state, which is also the state a visitor without JavaScript keeps.
final class BrowserClipboard implements Clipboard {
  const BrowserClipboard();

  @override
  Future<bool> write(String text) async {
    if (!kIsWeb) return false;

    try {
      await window.navigator.clipboard.writeText(text).toDart;
    } catch (_) {
      // A denied permission or an insecure origin. Say nothing rather than claim a copy that did not
      // happen — the address is on screen beside the button either way.
      return false;
    }

    return true;
  }
}
