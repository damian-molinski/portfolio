import 'dart:async';

import 'package:bloc/bloc.dart';

import '../content/site_content.dart';
import '../data/contact_dispatcher.dart';
import 'contact_draft.dart';
import 'contact_state.dart';

/// The consultation form's state, and the request behind it.
///
/// The design's `handleSend` was a 900ms `setTimeout` that reported success with nothing behind it.
/// Reproducing it would have meant telling a visitor their message arrived when nothing received it,
/// so this cubit refused to and shipped a documented no-op instead. It now waits on
/// [ContactDispatcher.send]: `transmitting` lasts exactly as long as the POST does, and
/// [DispatchStatus.failed] is a state the form can actually reach.
///
/// [ContactDraftBuilder] is private here and is never handed out. It is mutable, so a state holding
/// it would hand the same instance to its successor and `Equatable` would suppress the emit on every
/// keystroke; instead every [ContactState] is a fresh snapshot of it, taken in the one place that
/// emits. That is what keeps the two from drifting apart.
///
/// Validation runs here as well as through the native `required` attributes, so the message is the
/// same whether or not the browser gets there first.
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
      _emitDraft(showValidationError: true);
      return;
    }

    final draft = _draft.build();
    _emitDraft(status: DispatchStatus.transmitting, showValidationError: false);

    final wasAccepted = await _dispatcher.send(draft);
    if (isClosed) return;

    if (!wasAccepted) {
      // What the visitor typed stays in the fields. Losing it to a failed send would cost them the
      // whole message.
      _emitDraft(status: DispatchStatus.failed);
      return;
    }

    _draft.clear();
    _emitDraft(status: DispatchStatus.sent);

    _confirmation = Timer(_confirmationDuration, () {
      if (!isClosed) _emitDraft(status: DispatchStatus.idle);
    });
  }

  /// The only place this cubit emits.
  ///
  /// Every field the builder owns is read from it here, so a state can never carry a stale value
  /// forward. [status] and [showValidationError] are the two the builder does not own; omitting
  /// either keeps what the current state holds.
  void _emitDraft({DispatchStatus? status, bool? showValidationError}) {
    final snapshot = ContactState(
      name: _draft.name,
      email: _draft.email,
      brief: _draft.brief,
      scope: _draft.scope,
      status: status ?? state.status,
      showValidationError: showValidationError ?? state.showValidationError,
    );

    emit(snapshot);
  }

  @override
  Future<void> close() {
    _confirmation?.cancel();
    return super.close();
  }
}
