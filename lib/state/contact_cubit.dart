import 'dart:async';

import 'package:bloc/bloc.dart';

import '../content/site_content.dart';
import 'contact_state.dart';

/// The consultation form's state.
///
/// **This form does not send anything.** Decision D5: the design's `handleSend` was a 900ms
/// `setTimeout` that reported success without a request behind it, and reproducing that would mean
/// telling a visitor their message arrived when nothing received it. The sequence below is the
/// design's, minus the lie — [_dispatch] is a documented no-op.
///
/// Validation runs here as well as through the native `required` attributes, so the message is the
/// same whether or not the browser gets there first.
final class ContactCubit extends Cubit<ContactState> {
  ContactCubit({
    Duration transmitDuration = const Duration(milliseconds: 900),
    Duration confirmationDuration = const Duration(seconds: 3),
  }) : _transmitDuration = transmitDuration,
       _confirmationDuration = confirmationDuration,
       super(ContactState.initial());

  final Duration _transmitDuration;
  final Duration _confirmationDuration;

  Timer? _sequence;

  void updateField(ContactField field, String value) {
    final updatedValues = {...state.values, field: value};
    emit(state.copyWith(values: updatedValues));
  }

  void updateScope(ScopeOption scope) => emit(state.copyWith(scope: scope));

  /// Runs the submit sequence, or reports the fields that block it.
  void submit() {
    if (state.status.blocksSubmit) return;

    if (state.emptyRequiredFields.isNotEmpty) {
      emit(state.copyWith(showValidationError: true));
      return;
    }

    _dispatch();
    emit(state.copyWith(showValidationError: false, status: DispatchStatus.transmitting));

    _sequence = Timer(_transmitDuration, () {
      if (isClosed) return;
      final clearedForm = ContactState.initial();
      emit(clearedForm.copyWith(status: DispatchStatus.sent));

      _sequence = Timer(_confirmationDuration, () {
        if (!isClosed) emit(state.copyWith(status: DispatchStatus.idle));
      });
    });
  }

  /// Where a real submission would go.
  ///
  /// [[TODO: dispatch endpoint]] — until one exists, everything the visitor typed stays in the
  /// browser and is discarded on reset.
  void _dispatch() {}

  @override
  Future<void> close() {
    _sequence?.cancel();
    return super.close();
  }
}
