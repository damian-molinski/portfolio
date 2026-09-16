import 'package:equatable/equatable.dart';

import '../content/site_content.dart';
import '../utils/iterable_extensions.dart';

enum FieldProblem {
  missing,
  malformed,
}

final class ContactDraft extends Equatable {
  const ContactDraft({
    required this.name,
    required this.email,
    required this.brief,
    required this.scope,
    required this.honeypot,
  });

  final String name;
  final String email;
  final String brief;
  final ScopeOption scope;
  final String honeypot;

  @override
  List<Object?> get props => [name, email, brief, scope, honeypot];
}

final class ContactDraftBuilder {
  ContactDraftBuilder();

  // Deliberately loose, and matched by `functions/api/contact.ts` so a 400 means the same thing on
  // both sides of the wire.
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  String? name;
  String? email;
  String? brief;
  String? honeypot;
  ScopeOption scope = ScopeOption.initial;
  Map<ContactField, FieldProblem> get problems =>
      ContactField.values.map(_entryFor).whereType<MapEntry<ContactField, FieldProblem>>().toMap();

  bool get isComplete => problems.isEmpty;
  ContactDraft build() {
    final blockingFields = problems;

    if (blockingFields.isNotEmpty) {
      final blocking = blockingFields.entries.map((entry) => '${entry.key.name} is ${entry.value.name}');
      throw StateError('Cannot build a ContactDraft while ${blocking.join(', ')}.');
    }

    return ContactDraft(
      name: name!.trim(),
      email: email!.trim(),
      brief: brief!.trim(),
      scope: scope,
      honeypot: honeypot ?? '',
    );
  }

  void clear() {
    name = null;
    email = null;
    brief = null;
    honeypot = null;
    scope = ScopeOption.initial;
  }

  MapEntry<ContactField, FieldProblem>? _entryFor(ContactField field) {
    final problem = _problemWith(field);

    return problem == null ? null : MapEntry(field, problem);
  }

  FieldProblem? _problemWith(ContactField field) {
    final value = _valueOf(field)?.trim();

    if (value == null || value.isEmpty) return FieldProblem.missing;
    if (field.isEmail && !_emailPattern.hasMatch(value)) return FieldProblem.malformed;

    return null;
  }

  String? _valueOf(ContactField field) => switch (field) {
    ContactField.name => name,
    ContactField.email => email,
    ContactField.brief => brief,
  };
}
