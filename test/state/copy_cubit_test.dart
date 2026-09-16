import 'package:bloc_test/bloc_test.dart';
import 'package:portfolio/data/clipboard.dart';
import 'package:portfolio/state/copy_cubit.dart';
import 'package:portfolio/state/copy_state.dart';
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
  group(CopyCubit, () {
    const email = 'someone@example.test';

    blocTest<CopyCubit, CopyState>(
      'confirms the copy, then reverts once the confirmation window passes',
      build: () => CopyCubit(clipboard: _FakeClipboard(), confirmationDuration: Duration.zero),
      act: (cubit) => cubit.copy(email),
      wait: const Duration(milliseconds: 10),
      expect: () => const [CopyState.copied(), CopyState.idle()],
    );

    blocTest<CopyCubit, CopyState>(
      'says nothing when the write did not happen',
      build: () => CopyCubit(
        clipboard: _FakeClipboard(succeeds: false),
        confirmationDuration: Duration.zero,
      ),
      act: (cubit) => cubit.copy(email),
      wait: const Duration(milliseconds: 10),
      expect: () => const <CopyState>[],
    );

    test('writes the address it was handed', () async {
      final clipboard = _FakeClipboard();
      final cubit = CopyCubit(clipboard: clipboard, confirmationDuration: Duration.zero);
      addTearDown(cubit.close);

      await cubit.copy(email);

      expect(clipboard.writes, [email]);
    });

    test('cancelling on close leaves no timer to fire into a closed cubit', () async {
      final cubit = CopyCubit(
        clipboard: _FakeClipboard(),
        confirmationDuration: const Duration(seconds: 30),
      );

      await cubit.copy(email);
      await cubit.close();

      expect(cubit.state, const CopyState.copied());
    });
  });
}
