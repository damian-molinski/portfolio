import 'dart:async';

import 'package:bloc/bloc.dart';

import '../data/clipboard.dart';
import 'copy_state.dart';

/// Writes an address to the clipboard and confirms it for a couple of seconds.
///
/// Registered as a **factory**, not a singleton: the page renders `CopyEmailButton` twice, and a
/// shared instance would make both buttons confirm on one click.
final class CopyCubit extends Cubit<CopyState> {
  CopyCubit({
    required Clipboard clipboard,
    Duration confirmationDuration = const Duration(seconds: 2),
  }) : _clipboard = clipboard,
       _confirmationDuration = confirmationDuration,
       super(const CopyState.idle());

  final Clipboard _clipboard;
  final Duration _confirmationDuration;

  Timer? _revert;

  /// Copies [email], then reverts to idle after the confirmation window.
  ///
  /// A write that did not happen leaves the state alone rather than claiming success.
  Future<void> copy(String email) async {
    final didWrite = await _clipboard.write(email);
    if (!didWrite || isClosed) return;

    emit(const CopyState.copied());

    _revert?.cancel();
    _revert = Timer(_confirmationDuration, () {
      if (!isClosed) emit(const CopyState.idle());
    });
  }

  @override
  Future<void> close() {
    _revert?.cancel();
    return super.close();
  }
}
