import 'package:jaspr_test/server_test.dart';
import 'package:portfolio/ui/core/view/cosmos_backdrop.dart';

import '../components/render.dart';

void main() {
  useAppOptions();

  group(CosmosBackdrop, () {
    testServer('hides the whole layer from assistive technology', (tester) async {
      final rendered = await tester.render(const CosmosBackdrop());
      final layer = rendered.querySelector('.cosmos')!;

      expect(layer.attributes, containsPair('aria-hidden', 'true'));
      expect(rendered.querySelectorAll('.cosmos__star'), isNotEmpty);
    });

    testServer('gives every star exactly one twinkle class', (tester) async {
      final rendered = await tester.render(const CosmosBackdrop());
      final twinkleClasses = rendered
          .querySelectorAll('.cosmos__star')
          .map((star) => star.classes.where((name) => name.startsWith('star-twinkle-')));

      expect(twinkleClasses, everyElement(hasLength(1)));
    });

    testServer('places each star with left and top, never a transform', (tester) async {
      final rendered = await tester.render(const CosmosBackdrop());
      final inlineStyles = rendered.querySelectorAll('.cosmos__star').map((star) => star.attributes['style']!);

      expect(inlineStyles, everyElement(allOf(contains('left:'), contains('top:'))));
      expect(inlineStyles, everyElement(isNot(contains('transform'))));
    });

    testServer('drops the dense stars as a tail, so the field thins rather than gaps', (tester) async {
      final rendered = await tester.render(const CosmosBackdrop());
      final isDense = rendered
          .querySelectorAll('.cosmos__star')
          .map((star) => star.classes.contains('cosmos__star--dense'))
          .toList(growable: false);
      final firstDense = isDense.indexOf(true);

      expect(firstDense, isPositive);
      expect(isDense.sublist(firstDense), everyElement(isTrue));
      expect(isDense.sublist(0, firstDense), everyElement(isFalse));
    });

    testServer('renders the same field every time, so the pre-rendered HTML is stable', (tester) async {
      final first = await tester.render(const CosmosBackdrop());
      final second = await tester.render(const CosmosBackdrop());

      expect(second.querySelector('.cosmos__stars')!.innerHtml, first.querySelector('.cosmos__stars')!.innerHtml);
    });
  });
}
