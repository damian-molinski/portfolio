import 'package:equatable/equatable.dart';

import '../content/site_content.dart';
import 'contact_draft.dart';

enum DispatchStatus {
  idle,
  transmitting,
  sent,
  failed;

  bool get blocksSubmit => this == transmitting || this == sent;
}

enum DispatchFailure {
  network,
  rejected,
  rateLimited,
  mailer,
}

final class ContactState extends Equatable {
  const ContactState({
    required this.name,
    required this.email,
    required this.brief,
    required this.scope,
    required this.status,
    required this.problems,
    this.failure,
  });

  const ContactState.initial()
    : name = null,
      email = null,
      brief = null,
      scope = ScopeOption.initial,
      status = DispatchStatus.idle,
      problems = const {},
      failure = null;

  final String? name;
  final String? email;
  final String? brief;
  final ScopeOption scope;
  final DispatchStatus status;
  final Map<ContactField, FieldProblem> problems;
  final DispatchFailure? failure;

  @override
  List<Object?> get props => [
    name,
    email,
    brief,
    scope,
    status,
    problems,
    failure,
  ];
}
