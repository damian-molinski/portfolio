import 'package:bloc_test/bloc_test.dart';
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
    const email = 'someone@example.test';

    blocTest<CopyViewModel, CopyState>(
      'confirms the copy, then reverts once the confirmation window passes',
      build: () => CopyViewModel(clipboard: _FakeClipboard(), confirmationDuration: Duration.zero),
      act: (cubit) => cubit.copy(email),
      wait: const Duration(milliseconds: 10),
      expect: () => const [CopyState.copied(), CopyState.idle()],
    );

    blocTest<CopyViewModel, CopyState>(
      'says nothing when the write did not happen',
      build: () => CopyViewModel(
        clipboard: _FakeClipboard(succeeds: false),
        confirmationDuration: Duration.zero,
      ),
      act: (cubit) => cubit.copy(email),
      wait: const Duration(milliseconds: 10),
      expect: () => const <CopyState>[],
    );

    test('writes the address it was handed', () async {
      final clipboard = _FakeClipboard();
      final cubit = CopyViewModel(clipboard: clipboard, confirmationDuration: Duration.zero);
      addTearDown(cubit.close);

      await cubit.copy(email);

      expect(clipboard.writes, [email]);
    });

    test('cancelling on close leaves no timer to fire into a closed cubit', () async {
      final cubit = CopyViewModel(
        clipboard: _FakeClipboard(),
        confirmationDuration: const Duration(seconds: 30),
      );

      await cubit.copy(email);
      await cubit.close();

      expect(cubit.state, const CopyState.copied());
    });
  });
}
