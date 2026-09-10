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
import 'content/site_content.dart';
// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  //
  // [Document] renders the root document structure (<html>, <head> and <body>)
  // with the provided parameters and components.
  //
  // It carries no `styles:` list: every rule now comes from the `@css` declarations in
  // `constants/theme.dart` and the components themselves, so there is one place a style can live.
  final appDocument = Document(
    title: SiteMeta.title,
    lang: SiteMeta.locale,
    meta: const {'description': SiteMeta.description},
    head: [
      // The stylesheet itself is imported from theme.dart; these only open the connections early.
      link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
      link(
        rel: 'preconnect',
        href: 'https://fonts.gstatic.com',
        attributes: const {'crossorigin': ''},
      ),

      // PWA surface — the manifest and icons archived out of the design in Step 1.
      link(rel: 'manifest', href: SiteMeta.manifest),
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
      meta(name: 'theme-color', content: SiteMeta.themeColor),

      // Social and canonical metadata. Every value here is a placeholder: the canonical domain is
      // undecided and no preview image has been produced, so these must not go out as they are.
      link(rel: 'canonical', href: SiteMeta.canonical),
      meta(content: 'website', attributes: const {'property': 'og:type'}),
      meta(content: SiteMeta.ogTitle, attributes: const {'property': 'og:title'}),
      meta(content: SiteMeta.ogDescription, attributes: const {'property': 'og:description'}),
      meta(content: SiteMeta.ogImage, attributes: const {'property': 'og:image'}),
      meta(content: SiteMeta.canonical, attributes: const {'property': 'og:url'}),
      meta(name: 'twitter:card', content: 'summary_large_image'),
      meta(name: 'twitter:site', content: SiteMeta.twitterSite),
      meta(name: 'twitter:title', content: SiteMeta.ogTitle),
      meta(name: 'twitter:description', content: SiteMeta.ogDescription),
      meta(name: 'twitter:image', content: SiteMeta.ogImage),
    ],
    body: App(),
  );

  runApp(appDocument);
}
