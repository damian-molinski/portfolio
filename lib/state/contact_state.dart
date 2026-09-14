import 'package:equatable/equatable.dart';

import '../content/site_content.dart';

/// Where the submit button is in its sequence.
enum DispatchStatus {
  idle,
  transmitting,
  sent,
  failed;

  bool get blocksSubmit => this == transmitting || this == sent;
}

final class ContactState extends Equatable {
  const ContactState({
    required this.name,
    required this.email,
    required this.brief,
    required this.scope,
    required this.status,
    required this.showValidationError,
  });

  /// An empty form: no field filled, the first scope selected, nothing submitted.
  ContactState.initial()
    : name = null,
      email = null,
      brief = null,
      scope = ScopeOption.values.first,
      status = DispatchStatus.idle,
      showValidationError = false;

  final String? name;
  final String? email;
  final String? brief;
  final ScopeOption scope;
  final DispatchStatus status;
  final bool showValidationError;

  @override
  List<Object?> get props => [
    name,
    email,
    brief,
    scope,
    status,
    showValidationError,
  ];
}
