import 'dart:async';

import 'package:bloc/bloc.dart';

import '../content/site_content.dart';
import '../data/contact_dispatcher.dart';
import 'contact_draft.dart';
import 'contact_state.dart';

final class ContactCubit extends Cubit<ContactState> {
  ContactCubit({
    required ContactDispatcher dispatcher,
    Duration confirmationDuration = const Duration(seconds: 3),
  }) : _dispatcher = dispatcher,
       _confirmationDuration = confirmationDuration,
       super(ContactState.initial());

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

  /// Records the trap field, and emits nothing.
  ///
  /// The trap is not part of [ContactState] — no person sees it and nothing re-renders because of
  /// it — so there is no snapshot to take. It reaches the wire through [ContactDraftBuilder.build].
  void updateHoneypot(String value) => _draft.honeypot = value;

  /// Sends the form, or reports the fields that block it.
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
      // What the visitor typed stays in the fields. Losing it to a failed send would cost them the
      // whole message.
      _emitDraft(status: DispatchStatus.failed, failure: failure);
      return;
    }

    _draft.clear();
    _emitDraft(status: DispatchStatus.sent);

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
