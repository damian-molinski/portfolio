import 'dart:async';

import 'package:bloc/bloc.dart';

import '../data/clipboard.dart';
import 'copy_state.dart';

final class CopyCubit extends Cubit<CopyState> {
  CopyCubit({
    required this._clipboard,
    this._confirmationDuration = const Duration(seconds: 2),
  }) : super(const CopyState.idle());

  final Clipboard _clipboard;
  final Duration _confirmationDuration;

  Timer? _revert;
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
