import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../data/clipboard.dart';
import '../data/contact_dispatcher.dart';
import '../data/site_content_repository.dart';
import '../state/contact_cubit.dart';
import '../state/copy_cubit.dart';
import '../state/site_content_cubit.dart';

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
    ..registerLazySingleton<SiteContentCubit>(() => SiteContentCubit(getIt()))
    ..registerFactory<ContactCubit>(() => ContactCubit(dispatcher: getIt()))
    // A factory, not a singleton: the page renders `CopyEmailButton` twice, and a shared instance
    // would make both confirm on a single click.
    ..registerFactory<CopyCubit>(() => CopyCubit(clipboard: getIt()));
}
