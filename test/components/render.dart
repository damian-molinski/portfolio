import 'package:html/dom.dart';
import 'package:jaspr/jaspr.dart' hide Document;
import 'package:jaspr_test/server_test.dart';

extension ServerTesterRender on ServerTester {
  Future<Document> render(Component component) async {
    pumpComponent(component);
    final response = await request('/');

    return response.document!;
  }
}
