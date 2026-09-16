import 'package:html/dom.dart';
import 'package:jaspr/jaspr.dart' hide Document;
import 'package:jaspr_test/server_test.dart';

/// Renders a component through the server tester and hands back the parsed markup.
///
/// The assertions want the DOM rather than the response body: Jaspr escapes entities on the way
/// out, so a raw-string `contains` on any copy carrying an `&` or an apostrophe fails for a reason
/// that has nothing to do with what is being tested.
extension ServerTesterRender on ServerTester {
  Future<Document> render(Component component) async {
    pumpComponent(component);
    final response = await request('/');

    return response.document!;
  }
}
