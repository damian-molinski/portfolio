library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'data/repositories/site_content_repository.dart';
import 'di/injector.dart';
import 'main.server.options.dart';
import 'routing/routes.dart';
import 'ui/core/binding/bloc_provider.dart';
import 'ui/core/view_model/app_shell_view_model.dart';

void main() {
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  configureDependencies();

  final siteMeta = getIt<SiteContentRepository>().load().meta;

  final appDocument = Document(
    title: siteMeta.title,
    lang: siteMeta.locale,
    meta: {'description': siteMeta.description},
    head: [
      link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
      link(
        rel: 'preconnect',
        href: 'https://fonts.gstatic.com',
        attributes: const {'crossorigin': ''},
      ),

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
      link(rel: 'canonical', href: siteMeta.canonical),
      meta(content: 'website', attributes: const {'property': 'og:type'}),
      meta(content: siteMeta.ogTitle, attributes: const {'property': 'og:title'}),
      meta(content: siteMeta.ogDescription, attributes: const {'property': 'og:description'}),
      meta(content: siteMeta.ogImage, attributes: const {'property': 'og:image'}),
      meta(content: siteMeta.canonical, attributes: const {'property': 'og:url'}),
      meta(name: 'twitter:card', content: 'summary_large_image'),
      meta(name: 'twitter:title', content: siteMeta.ogTitle),
      meta(name: 'twitter:description', content: siteMeta.ogDescription),
      meta(name: 'twitter:image', content: siteMeta.ogImage),
    ],
    body: BlocProvider<AppShellViewModel>.value(
      value: getIt(),
      child: Router(
        routes: routes,
        redirect: (context, state) {
          print('Redirect: $state');
          return state.location != '/' ? '/' : null;
        },
      ),
    ),
  );

  runApp(appDocument);
}
