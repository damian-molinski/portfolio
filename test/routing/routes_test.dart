import 'package:jaspr_router/jaspr_router.dart';
import 'package:jaspr_test/server_test.dart';
import 'package:portfolio/di/injector.dart';
import 'package:portfolio/domain/models/site_content.dart';
import 'package:portfolio/routing/routes.dart';
import 'package:portfolio/ui/core/binding/bloc_provider.dart';
import 'package:portfolio/ui/core/view_model/app_shell_view_model.dart';

import '../ui/core/components/render.dart';

void main() {
  useAppOptions();

  setUp(configureDependencies);
  tearDown(getIt.reset);

  group(Router, () {
    testServer('wraps the routed page in the shell it renders under', (tester) async {
      const chrome = ChromeContent();

      final rendered = await tester.render(
        BlocProvider<AppShellViewModel>.value(
          value: getIt(),
          child: Router(routes: routes),
        ),
      );

      expect(rendered.querySelector('main#${chrome.mainId}'), isNotNull);
      expect(rendered.querySelector('section#${SiteSection.pillars.id}'), isNotNull);
    });
  });
}
