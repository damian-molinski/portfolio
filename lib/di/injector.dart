import 'package:get_it/get_it.dart';

import '../data/clipboard.dart';
import '../data/site_content_repository.dart';
import '../state/contact_cubit.dart';
import '../state/copy_cubit.dart';
import '../state/site_content_cubit.dart';

/// The service locator, shared by both entrypoints.
///
/// The pre-rendered tree reaches it once, in `main.server.dart`, to put [SiteContentCubit] above
/// `App`. The two `@client` islands hydrate as separate trees and cannot see anything provided
/// above them, so they resolve from here directly — which is safe only because the content is
/// `const`-backed and deterministic, so server and client compute the same markup from the same
/// literals. A runtime content source would break that and this decision would have to be revisited.
final getIt = GetIt.instance;

/// Registers everything the page needs. Safe to call more than once, so `jaspr serve`'s reload
/// cannot throw on a duplicate registration.
void configureDependencies() {
  if (getIt.isRegistered<SiteContentRepository>()) return;

  getIt
    ..registerSingleton<SiteContentRepository>(const ConstSiteContentRepository())
    ..registerSingleton<Clipboard>(const BrowserClipboard())
    ..registerLazySingleton<SiteContentCubit>(() => SiteContentCubit(getIt()))
    ..registerFactory<ContactCubit>(ContactCubit.new)
    // A factory, not a singleton: the page renders `CopyEmailButton` twice, and a shared instance
    // would make both buttons confirm on a single click.
    ..registerFactory<CopyCubit>(() => CopyCubit(clipboard: getIt()));
}
