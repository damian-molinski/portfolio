import 'package:bloc_test/bloc_test.dart';
import 'package:portfolio/data/repositories/site_content_repository.dart';
import 'package:portfolio/data/services/clipboard.dart';
import 'package:portfolio/ui/copy_email/view_model/copy_state.dart';
import 'package:portfolio/ui/copy_email/view_model/copy_view_model.dart';
import 'package:test/test.dart';

final class _FakeClipboard implements Clipboard {
  _FakeClipboard({this.succeeds = true});

  final bool succeeds;
  final writes = <String>[];

  @override
  Future<bool> write(String text) async {
    writes.add(text);
    return succeeds;
  }
}

void main() {
  group(CopyViewModel, () {
    const repository = ConstSiteContentRepository();
    final content = repository.load();
    final idle = CopyState.idle(
      email: content.identity.email,
      label: content.hero.copyCta,
      successLabel: content.hero.copyCtaSuccess,
      ariaLabel: content.hero.copyCtaAriaLabel,
    );

    test('carries the address and the three labels the button renders', () {
      final cubit = CopyViewModel(repository: repository, clipboard: _FakeClipboard());
      addTearDown(cubit.close);

      expect(cubit.state, idle);
      expect(cubit.state.email, content.identity.email);
      expect(cubit.state.isCopied, isFalse);
    });

    group('copy', () {
      blocTest<CopyViewModel, CopyState>(
        'confirms the copy, then reverts once the confirmation window passes',
        build: () => CopyViewModel(
          repository: repository,
          clipboard: _FakeClipboard(),
          confirmationDuration: Duration.zero,
        ),
        act: (cubit) => cubit.copy(),
        wait: const Duration(milliseconds: 10),
        expect: () => [idle.confirmed(), idle.reverted()],
      );

      blocTest<CopyViewModel, CopyState>(
        'says nothing when the write did not happen',
        build: () => CopyViewModel(
          repository: repository,
          clipboard: _FakeClipboard(succeeds: false),
          confirmationDuration: Duration.zero,
        ),
        act: (cubit) => cubit.copy(),
        wait: const Duration(milliseconds: 10),
        expect: () => const <CopyState>[],
      );

      test('writes the address the content declares, without being handed one', () async {
        final clipboard = _FakeClipboard();
        final cubit = CopyViewModel(
          repository: repository,
          clipboard: clipboard,
          confirmationDuration: Duration.zero,
        );
        addTearDown(cubit.close);

        await cubit.copy();

        expect(clipboard.writes, [content.identity.email]);
      });

      test('cancelling on close leaves no timer to fire into a closed cubit', () async {
        final cubit = CopyViewModel(
          repository: repository,
          clipboard: _FakeClipboard(),
          confirmationDuration: const Duration(seconds: 30),
        );

        await cubit.copy();
        await cubit.close();

        expect(cubit.state, idle.confirmed());
      });
    });
  });
}
