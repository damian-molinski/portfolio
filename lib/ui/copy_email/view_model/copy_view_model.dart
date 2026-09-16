import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../data/repositories/site_content_repository.dart';
import '../../../data/services/clipboard.dart';
import '../../../domain/models/site_content.dart';
import 'copy_state.dart';

final class CopyViewModel extends Cubit<CopyState> {
  CopyViewModel({
    required SiteContentRepository repository,
    required this._clipboard,
    this._confirmationDuration = const Duration(seconds: 2),
  }) : super(_seed(repository.load()));

  final Clipboard _clipboard;
  final Duration _confirmationDuration;

  Timer? _revert;

  static CopyState _seed(SiteContent content) {
    return CopyState.idle(
      email: content.identity.email,
      label: content.hero.copyCta,
      successLabel: content.hero.copyCtaSuccess,
      ariaLabel: content.hero.copyCtaAriaLabel,
    );
  }

  Future<void> copy() async {
    final didWrite = await _clipboard.write(state.email);
    if (!didWrite || isClosed) return;

    emit(state.confirmed());

    _revert?.cancel();
    _revert = Timer(_confirmationDuration, () {
      if (!isClosed) emit(state.reverted());
    });
  }

  @override
  Future<void> close() {
    _revert?.cancel();
    return super.close();
  }
}
