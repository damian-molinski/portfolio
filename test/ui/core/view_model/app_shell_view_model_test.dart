import 'package:bloc_test/bloc_test.dart';
import 'package:portfolio/data/repositories/site_content_repository.dart';
import 'package:portfolio/ui/core/view_model/app_shell_state.dart';
import 'package:portfolio/ui/core/view_model/app_shell_view_model.dart';
import 'package:test/test.dart';

void main() {
  group(AppShellViewModel, () {
    const repository = ConstSiteContentRepository();
    final content = repository.load();

    test('has the chrome it renders from the first build, with no loading state in between', () {
      final cubit = AppShellViewModel(repository);
      addTearDown(cubit.close);

      expect(cubit.state, AppShellState.from(content));
      expect(cubit.state.identity, content.identity);
      expect(cubit.state.sections, content.sections);
      expect(cubit.state.footerLinks, content.footerLinks);
      expect(cubit.state.chrome, content.chrome);
    });

    blocTest<AppShellViewModel, AppShellState>(
      'never emits again — the static tree has no second state to receive',
      build: () => AppShellViewModel(repository),
      wait: const Duration(milliseconds: 10),
      expect: () => const <AppShellState>[],
    );
  });
}
