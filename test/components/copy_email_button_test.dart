import 'package:jaspr_test/server_test.dart';
import 'package:portfolio/components/copy_email_button.dart';
import 'package:portfolio/content/site_content.dart';
import 'package:portfolio/data/clipboard.dart';
import 'package:portfolio/di/injector.dart';
import 'package:portfolio/state/copy_cubit.dart';

import 'render.dart';

final class _FakeClipboard implements Clipboard {
  @override
  Future<bool> write(String text) async => true;
}

void main() {
  useAppOptions();

  const hero = HeroContent();
  const identity = SiteIdentity();

  late CopyCubit copy;

  setUp(() {
    configureDependencies();

    getIt.unregister<Clipboard>();
    getIt.registerSingleton<Clipboard>(_FakeClipboard());

    copy = CopyCubit(clipboard: getIt());
    getIt.unregister<CopyCubit>();
    getIt.registerSingleton<CopyCubit>(copy);
  });

  tearDown(() async {
    await copy.close();
    await getIt.reset();
  });

  group(CopyEmailButton, () {
    testServer('renders the labelled treatment with its call to action', (tester) async {
      final rendered = await tester.render(const CopyEmailButton(isIconOnly: false));
      final control = rendered.querySelector('button')!;

      expect(control.classes, contains('mono-button'));
      expect(control.text, contains(hero.copyCta));
      expect(control.attributes, containsPair('aria-label', hero.copyCtaAriaLabel));
    });

    testServer('renders the icon-only treatment as a named bare glyph', (tester) async {
      final rendered = await tester.render(const CopyEmailButton(isIconOnly: true));
      final control = rendered.querySelector('button')!;

      expect(control.classes, contains('copy-icon-button'));
      expect(control.text.trim(), isEmpty);
      expect(control.attributes, containsPair('aria-label', hero.copyCtaAriaLabel));
    });

    testServer('swaps the label once a write has landed', (tester) async {
      await copy.copy(identity.email);

      final rendered = await tester.render(const CopyEmailButton(isIconOnly: false));

      expect(rendered.querySelector('button')!.text, contains(hero.copyCtaSuccess));
      expect(rendered.querySelector('button')!.text, isNot(contains(hero.copyCta)));
    });

    testServer('swaps the glyph once a write has landed', (tester) async {
      await copy.copy(identity.email);

      final rendered = await tester.render(const CopyEmailButton(isIconOnly: true));

      expect(rendered.querySelector('.copy-icon-button__glyph--done'), isNotNull);
    });
  });
}
