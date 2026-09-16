import 'package:jaspr/jaspr.dart';

import 'sections/contact.dart';
import 'sections/hero.dart';
import 'sections/pillars.dart';
import 'sections/projects.dart';
import 'sections/signals_dock.dart';
import 'sections/skills.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment(
      const [
        Hero(),
        SignalsDock(),
        Pillars(),
        Skills(),
        Projects(),
        Contact(),
      ],
    );
  }
}
