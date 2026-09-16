import 'package:equatable/equatable.dart';

import '../../../domain/models/site_content.dart';

final class HomeState extends Equatable {
  const HomeState({
    required this.hero,
    required this.signals,
    required this.identityNodes,
    required this.pillars,
    required this.skillGroups,
    required this.projects,
    required this.projectLabels,
    required this.contactCards,
  });

  factory HomeState.from(SiteContent content) {
    return HomeState(
      hero: content.hero,
      signals: content.signals,
      identityNodes: content.identityNodes,
      pillars: content.pillars,
      skillGroups: content.skillGroups,
      projects: content.projects,
      projectLabels: content.projectLabels,
      contactCards: content.contactCards,
    );
  }

  final HeroContent hero;
  final SignalsContent signals;
  final List<IdentityNode> identityNodes;
  final List<Pillar> pillars;
  final List<SkillGroup> skillGroups;
  final List<Project> projects;
  final ProjectContent projectLabels;
  final List<ContactCard> contactCards;

  @override
  List<Object?> get props => [
    hero,
    signals,
    identityNodes,
    pillars,
    skillGroups,
    projects,
    projectLabels,
    contactCards,
  ];
}
