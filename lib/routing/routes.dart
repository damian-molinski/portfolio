import 'package:jaspr_router/jaspr_router.dart';

import '../di/injector.dart';
import '../ui/core/binding/bloc_provider.dart';
import '../ui/core/view/app_shell.dart';
import '../ui/home/view/home_page.dart';
import '../ui/home/view_model/home_view_model.dart';

List<RouteBase> get routes => [
  ShellRoute(
    builder: (context, state, child) => AppShell(child: child),
    routes: [
      Route(
        path: '/',
        settings: const RouteSettings(changeFreq: ChangeFreq.monthly, priority: 1.0),
        builder: (context, state) {
          return BlocProvider<HomeViewModel>.value(value: getIt(), child: const HomePage());
        },
      ),
    ],
  ),
];
