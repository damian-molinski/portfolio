import 'package:html/dom.dart';
import 'package:jaspr/server.dart' hide Document;
import 'package:jaspr_test/server_test.dart';
import 'package:portfolio/main.server.options.dart';

/// Registers the generated server options for the file, so an island renders with the hydration
/// boundary and the client script the built site emits. `ServerTester` reads `Jaspr.options` when it
/// is constructed, so this cannot run inside a `testServer` callback.
void useAppOptions() => setUpAll(() => Jaspr.initializeApp(options: defaultServerOptions));

extension ServerTesterRender on ServerTester {
  Future<Document> render(Component component) async {
    pumpComponent(component);
    final response = await request('/');

    return response.document!;
  }
}
