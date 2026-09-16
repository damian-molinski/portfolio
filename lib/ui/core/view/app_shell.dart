import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../domain/models/site_content.dart';
import '../../home/view/sections/contact.dart';
import '../../home/view/sections/hero.dart';
import '../../home/view/sections/pillars.dart';
import '../../home/view/sections/projects.dart';
import '../../home/view/sections/signals_dock.dart';
import '../../home/view/sections/skills.dart';
import '../theme.dart';
import '../view_model/site_content_builder.dart';
import 'site_footer.dart';
import 'site_header.dart';

class AppShell extends StatelessComponent {
  const AppShell({super.key});

  @override
  Component build(BuildContext context) {
    return SiteContentBuilder(builder: (context, content) => _page(content.chrome));
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
