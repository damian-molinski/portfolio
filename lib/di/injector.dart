import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../data/repositories/site_content_repository.dart';
import '../data/services/clipboard.dart';
import '../data/services/contact_dispatcher.dart';
import '../ui/contact/view_model/contact_view_model.dart';
import '../ui/copy_email/view_model/copy_view_model.dart';
import '../ui/core/view_model/app_shell_view_model.dart';
import '../ui/home/view_model/home_view_model.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  if (getIt.isRegistered<SiteContentRepository>()) return;

  getIt
    ..registerSingleton<SiteContentRepository>(const ConstSiteContentRepository())
    ..registerSingleton<Clipboard>(const BrowserClipboard())
    ..registerLazySingleton<http.Client>(http.Client.new)
    ..registerLazySingleton<ContactDispatcher>(() {
      return HttpContactDispatcher(client: getIt(), base: Uri.base);
    })
    ..registerLazySingleton<AppShellViewModel>(() => AppShellViewModel(getIt()))
    ..registerLazySingleton<HomeViewModel>(() => HomeViewModel(getIt()))
    ..registerFactory<ContactViewModel>(() {
      return ContactViewModel(repository: getIt(), dispatcher: getIt());
    })
    // A factory, not a singleton: the page renders `CopyEmailButton` twice, and a shared instance
    // would make both confirm on a single click.
    ..registerFactory<CopyViewModel>(() {
      return CopyViewModel(repository: getIt(), clipboard: getIt());
    });
}
