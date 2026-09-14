import 'package:equatable/equatable.dart';

import '../content/site_content.dart';

/// Where the submit button is in its sequence.
enum DispatchStatus {
  idle,
  transmitting,
  sent;

  /// The button is inert while the sequence runs, so a second press cannot start it again.
  bool get blocksSubmit => this != idle;
}

/// Everything the visitor has typed, and where the submit sequence has got to.
final class ContactState extends Equatable {
  const ContactState({
    required this.values,
    required this.scope,
    required this.status,
    required this.showValidationError,
  });

  /// An empty form: no field filled, the first scope selected, nothing submitted.
  ContactState.initial()
    : values = {for (final field in ContactField.values) field: ''},
      scope = ScopeOption.values.first,
      status = DispatchStatus.idle,
      showValidationError = false;

  final Map<ContactField, String> values;
  final ScopeOption scope;
  final DispatchStatus status;

  /// Set when a submit was rejected, cleared when the next one is accepted.
  final bool showValidationError;

  /// The required fields the visitor has left blank. Empty means the form may be submitted.
  Iterable<ContactField> get emptyRequiredFields =>
      ContactField.values.where((field) => field.isRequired && values[field]!.trim().isEmpty);

  ContactState copyWith({
    Map<ContactField, String>? values,
    ScopeOption? scope,
    DispatchStatus? status,
    bool? showValidationError,
  }) {
    return ContactState(
      values: values ?? this.values,
      scope: scope ?? this.scope,
      status: status ?? this.status,
      showValidationError: showValidationError ?? this.showValidationError,
    );
  }

  @override
  List<Object?> get props => [values, scope, status, showValidationError];
}
