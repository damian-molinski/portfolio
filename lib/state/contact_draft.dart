import 'package:equatable/equatable.dart';

import '../content/site_content.dart';

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

  String? name;
  String? email;
  String? brief;
  String? honeypot;
  ScopeOption scope = ScopeOption.values.first;

  Iterable<ContactField> get missingFields => ContactField.values.where(_isMissing);

  bool get isComplete => missingFields.isEmpty;

  /// The draft as it stands.
  ContactDraft build() {
    final blankFields = missingFields;

    if (blankFields.isNotEmpty) {
      final blankNames = blankFields.map((field) => field.name).join(', ');
      throw StateError('Cannot build a ContactDraft while $blankNames is blank.');
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
    scope = ScopeOption.values.first;
  }

  bool _isMissing(ContactField field) {
    if (!field.isRequired) return false;

    final value = _valueOf(field);
    return value == null || value.trim().isEmpty;
  }

  /// The one place the enum and the named fields meet. Exhaustive, so a new [ContactField] member is
  /// a compile error here rather than a field that silently never blocks a submit.
  String? _valueOf(ContactField field) => switch (field) {
    ContactField.name => name,
    ContactField.email => email,
    ContactField.brief => brief,
  };
}
