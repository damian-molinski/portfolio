import 'package:equatable/equatable.dart';

import '../content/site_content.dart';
import '../utils/iterable_extensions.dart';

/// What is wrong with one field's value.
enum FieldProblem {
  /// Required, and blank.
  missing,

  /// Filled, but not in a shape the field accepts.
  malformed,
}

/// A completed consultation enquiry, ready to post.
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

  /// The request body the contact endpoint reads. The trap goes over the wire as `company`, which
  /// is what it is called in the markup.
  Map<String, Object?> toJson() => {
    'name': name,
    'email': email,
    'brief': brief,
    'scope': scope.value,
    'company': honeypot,
  };

  @override
  List<Object?> get props => [name, email, brief, scope, honeypot];
}

/// Collects what the visitor types until it amounts to a [ContactDraft].
final class ContactDraftBuilder {
  ContactDraftBuilder();

  /// Deliberately loose: an `@` with something either side of it and a dot in the domain.
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  String? name;
  String? email;
  String? brief;
  String? honeypot;
  ScopeOption scope = ScopeOption.initial;

  /// What blocks the submit, by field. Empty when the draft is ready to post.
  Map<ContactField, FieldProblem> get problems =>
      ContactField.values.map(_entryFor).whereType<MapEntry<ContactField, FieldProblem>>().toMap();

  bool get isComplete => problems.isEmpty;

  /// The draft as it stands.
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

  /// Returns the builder to the state an untouched form is in.
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

  /// The one place the enum and the named fields meet. Exhaustive, so a new [ContactField] member is
  /// a compile error here rather than a field that silently never blocks a submit.
  String? _valueOf(ContactField field) => switch (field) {
    ContactField.name => name,
    ContactField.email => email,
    ContactField.brief => brief,
  };
}
