import 'dart:async';

import 'package:bloc/bloc.dart';

import '../content/site_content.dart';
import '../data/contact_dispatcher.dart';
import 'contact_draft.dart';
import 'contact_state.dart';

final class ContactCubit extends Cubit<ContactState> {
  ContactCubit({
    required this._dispatcher,
    this._confirmationDuration = const Duration(seconds: 3),
  }) : super(ContactState.initial());

  final ContactDispatcher _dispatcher;
  final Duration _confirmationDuration;

  final ContactDraftBuilder _draft = ContactDraftBuilder();

  bool _isValidated = false;
  Timer? _confirmation;

  void updateName(String value) {
    _draft.name = value;
    _emitDraft();
  }

  void updateEmail(String value) {
    _draft.email = value;
    _emitDraft();
  }

  void updateBrief(String value) {
    _draft.brief = value;
    _emitDraft();
  }

  void updateScope(ScopeOption scope) {
    _draft.scope = scope;
    _emitDraft();
  }

  void updateHoneypot(String value) => _draft.honeypot = value;
  Future<void> submit() async {
    if (state.status.blocksSubmit) return;

    if (!_draft.isComplete) {
      _emitDraft(isValidated: true);
      return;
    }

    final draft = _draft.build();
    _emitDraft(status: DispatchStatus.transmitting);

    final failure = await _dispatcher.send(draft);
    if (isClosed) return;

    if (failure case final failure?) {
      // What the visitor typed stays in the fields.
      _emitDraft(status: DispatchStatus.failed, failure: failure);
      return;
    }

    // Both, together: the draft is empty again, so leaving validation on would re-derive a problem
    // for every field and report the send that just succeeded as three blocked ones.
    _draft.clear();
    _emitDraft(status: DispatchStatus.sent, isValidated: false);

    _confirmation = Timer(_confirmationDuration, () {
      if (!isClosed) _emitDraft(status: DispatchStatus.idle);
    });
  }

  void _emitDraft({DispatchStatus? status, bool? isValidated, DispatchFailure? failure}) {
    final nextStatus = status ?? state.status;
    if (isValidated != null) _isValidated = isValidated;

    final snapshot = ContactState(
      name: _draft.name,
      email: _draft.email,
      brief: _draft.brief,
      scope: _draft.scope,
      status: nextStatus,
      failure: nextStatus == DispatchStatus.failed ? failure ?? state.failure : null,
      problems: _isValidated ? _draft.problems : const {},
    );

    emit(snapshot);
  }

  @override
  Future<void> close() {
    _confirmation?.cancel();
    return super.close();
  }
}
