import 'package:bloc_test/bloc_test.dart';
import 'package:portfolio/data/site_content_repository.dart';
import 'package:portfolio/state/site_content_cubit.dart';
import 'package:portfolio/state/site_content_state.dart';
import 'package:test/test.dart';

void main() {
  group(SiteContentCubit, () {
    const repository = ConstSiteContentRepository();

    test('has its content from the first build, with no loading state in between', () {
      final cubit = SiteContentCubit(repository);
      addTearDown(cubit.close);

      expect(cubit.state, SiteContentLoaded(repository.load()));
    });

    blocTest<SiteContentCubit, SiteContentState>(
      'never emits again — the static tree has no second state to receive',
      build: () => SiteContentCubit(repository),
      wait: const Duration(milliseconds: 10),
      expect: () => const <SiteContentState>[],
    );
  });
}
