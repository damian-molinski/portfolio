/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'package:jaspr/dom.dart';
// Server-specific Jaspr import.
import 'package:jaspr/server.dart';

// Imports the [App] component.
import 'app.dart';
import 'data/site_content_repository.dart';
import 'di/injector.dart';
// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';
import 'state/bloc_provider.dart';
import 'state/site_content_cubit.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  configureDependencies();

  // The `<head>` is built outside the component tree, so there is no `BlocBuilder` to read it
  // through. This is the one place the repository is used directly.
  final siteMeta = getIt<SiteContentRepository>().load().meta;

  // Starts the app.
  //
  // [Document] renders the root document structure (<html>, <head> and <body>)
  // with the provided parameters and components.
  //
  // It carries no `styles:` list: every rule now comes from the `@css` declarations in
  // `constants/theme.dart` and the components themselves, so there is one place a style can live.
  final appDocument = Document(
    title: siteMeta.title,
    lang: siteMeta.locale,
    meta: {'description': siteMeta.description},
    head: [
      // The stylesheet itself is imported from theme.dart; these only open the connections early.
      link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
      link(
        rel: 'preconnect',
        href: 'https://fonts.gstatic.com',
        attributes: const {'crossorigin': ''},
      ),

      // PWA surface — the manifest and icons archived out of the design in Step 1.
      link(rel: 'manifest', href: siteMeta.manifest),
      link(
        rel: 'icon',
        href: '/favicon.ico',
        type: 'image/x-icon',
        attributes: const {'sizes': '48x48 32x32 16x16'},
      ),
      link(
        rel: 'apple-touch-icon',
        href: '/icons/apple-touch-icon.png',
        attributes: const {'sizes': '180x180'},
      ),
      meta(name: 'theme-color', content: siteMeta.themeColor),

      // Social and canonical metadata. Every value here is a placeholder: the canonical domain is
      // undecided and no preview image has been produced, so these must not go out as they are.
      link(rel: 'canonical', href: siteMeta.canonical),
      meta(content: 'website', attributes: const {'property': 'og:type'}),
      meta(content: siteMeta.ogTitle, attributes: const {'property': 'og:title'}),
      meta(content: siteMeta.ogDescription, attributes: const {'property': 'og:description'}),
      meta(content: siteMeta.ogImage, attributes: const {'property': 'og:image'}),
      meta(content: siteMeta.canonical, attributes: const {'property': 'og:url'}),
      meta(name: 'twitter:card', content: 'summary_large_image'),
      meta(name: 'twitter:site', content: siteMeta.twitterSite),
      meta(name: 'twitter:title', content: siteMeta.ogTitle),
      meta(name: 'twitter:description', content: siteMeta.ogDescription),
      meta(name: 'twitter:image', content: siteMeta.ogImage),
    ],
    body: BlocProvider<SiteContentCubit>(
      create: (context) => getIt(),
      child: const App(),
    ),
  );

  runApp(appDocument);
}
