import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'constants/theme.dart';
import 'content/site_content.dart';
import 'sections/contact.dart';
import 'sections/hero.dart';
import 'sections/pillars.dart';
import 'sections/projects.dart';
import 'sections/signals_dock.dart';
import 'sections/site_footer.dart';
import 'sections/site_header.dart';
import 'sections/skills.dart';
import 'state/bloc_builder.dart';
import 'state/site_content_cubit.dart';
import 'state/site_content_state.dart';

/// The whole page.
///
/// Not `@client`: decision D5 puts the only JavaScript on the site in `CopyEmailButton` and
/// `ContactForm`, and `ClientApp` in `main.client.dart` finds and hydrates those two on its own.
/// Annotating the root instead would compile every section to JavaScript and hydrate the entire
/// document, which is the opposite of what a static build is for.
///
/// `padding-top` on `<main>` clears the fixed header, which is out of flow and would otherwise sit
/// over the top of the hero.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return BlocBuilder<SiteContentCubit, SiteContentState>(
      builder: (context, state) => _page(state.content.chrome),
    );
  }

  Component _page(ChromeContent chrome) {
    return Component.fragment([
      a(classes: 'skip-link', href: chrome.mainAnchor, [.text(chrome.skipLink)]),

      const SiteHeader(),

      main_(
        classes: 'site-main',
        id: chrome.mainId,
        // The skip link moves focus here, and `<main>` is not focusable without this.
        attributes: const {'tabindex': '-1'},
        [
          const Hero(),
          const SignalsDock(),
          const Pillars(),
          const Skills(),
          const Projects(),
          const Contact(),
        ],
      ),

      const SiteFooter(),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-main').styles(
      display: .block,
      width: 100.percent,
      padding: .only(top: 4.rem),
      outline: const Outline(style: .none),
      backgroundColor: AppColors.surface,
    ),
  ];
}
