import 'package:bloc_test/bloc_test.dart';
import 'package:portfolio/data/repositories/site_content_repository.dart';
import 'package:portfolio/ui/core/view_model/site_content_state.dart';
import 'package:portfolio/ui/core/view_model/site_content_view_model.dart';
import 'package:test/test.dart';

void main() {
  group(SiteContentViewModel, () {
    const repository = ConstSiteContentRepository();

    test('has its content from the first build, with no loading state in between', () {
      final cubit = SiteContentViewModel(repository);
      addTearDown(cubit.close);

      expect(cubit.state, SiteContentState(repository.load()));
    });

    blocTest<SiteContentViewModel, SiteContentState>(
      'never emits again — the static tree has no second state to receive',
      build: () => SiteContentViewModel(repository),
      wait: const Duration(milliseconds: 10),
      expect: () => const <SiteContentState>[],
    );
  });
}
