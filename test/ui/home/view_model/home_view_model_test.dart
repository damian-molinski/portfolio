import 'package:bloc_test/bloc_test.dart';
import 'package:portfolio/data/repositories/site_content_repository.dart';
import 'package:portfolio/ui/home/view_model/home_state.dart';
import 'package:portfolio/ui/home/view_model/home_view_model.dart';
import 'package:test/test.dart';

void main() {
  group(HomeViewModel, () {
    const repository = ConstSiteContentRepository();
    final content = repository.load();

    test('carries the eight slices the sections read, and nothing the chrome owns', () {
      final cubit = HomeViewModel(repository);
      addTearDown(cubit.close);

      expect(cubit.state, HomeState.from(content));
      expect(cubit.state.hero, content.hero);
      expect(cubit.state.signals, content.signals);
      expect(cubit.state.identityNodes, content.identityNodes);
      expect(cubit.state.pillars, content.pillars);
      expect(cubit.state.skillGroups, content.skillGroups);
      expect(cubit.state.projects, content.projects);
      expect(cubit.state.projectLabels, content.projectLabels);
      expect(cubit.state.contactCards, content.contactCards);
    });

    blocTest<HomeViewModel, HomeState>(
      'never emits again — the static tree has no second state to receive',
      build: () => HomeViewModel(repository),
      wait: const Duration(milliseconds: 10),
      expect: () => const <HomeState>[],
    );
  });
}
