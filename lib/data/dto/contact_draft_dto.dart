import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/contact_draft.dart';

part 'contact_draft_dto.g.dart';

@JsonSerializable(createFactory: false)
final class ContactDraftDto {
  const ContactDraftDto({
    required this.name,
    required this.email,
    required this.brief,
    required this.scope,
    required this.honeypot,
  });

  final String name;
  final String email;
  final String brief;
  final String scope;
  @JsonKey(name: 'company')
  final String honeypot;

  Map<String, Object?> toJson() => _$ContactDraftDtoToJson(this);
}

extension ContactDraftSerialization on ContactDraft {
  ContactDraftDto toDto() => ContactDraftDto(
    name: name,
    email: email,
    brief: brief,
    scope: scope.value,
    honeypot: honeypot,
  );
}
