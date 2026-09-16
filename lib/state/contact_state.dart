import 'package:equatable/equatable.dart';

import '../content/site_content.dart';
import 'contact_draft.dart';

/// Where the submit button is in its sequence.
enum DispatchStatus {
  idle,
  transmitting,
  sent,
  failed;

  bool get blocksSubmit => this == transmitting || this == sent;
}

/// Why a send did not arrive.
///
/// Each member is a different thing the visitor can do next, which is the only reason to tell them
/// apart: retry once the connection is back, fix what they typed, wait, or use the address in the
/// card above. The endpoint answers with a status and no body, so this is mapped from the status
/// code in [HttpContactDispatcher] rather than read out of a payload.
enum DispatchFailure {
  /// Nothing answered: offline, DNS, a refused connection, or the request timed out.
  network,

  /// The endpoint answered `400` — it read the body and would not take it.
  rejected,

  /// `429`. Resend's own limit, or the edge's.
  rateLimited,

  /// `502`, `503`, or any other refusal. Delivery is down, and not the visitor's to fix.
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

  /// An empty form: no field filled, the default scope selected, nothing submitted.
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
