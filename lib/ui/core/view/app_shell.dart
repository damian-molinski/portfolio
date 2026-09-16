import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../domain/models/site_content.dart';
import '../binding/bloc_builder.dart';
import '../theme.dart';
import '../view_model/app_shell_state.dart';
import '../view_model/app_shell_view_model.dart';
import 'site_footer.dart';
import 'site_header.dart';

class AppShell extends StatelessComponent {
  const AppShell({required this.child, super.key});

  final Component child;

  @override
  Component build(BuildContext context) {
    return BlocBuilder<AppShellViewModel, AppShellState>(
      builder: (context, state) => _page(state.chrome),
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
        [child],
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
