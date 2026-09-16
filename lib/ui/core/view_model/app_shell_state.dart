import 'package:equatable/equatable.dart';

import '../../../domain/models/site_content.dart';

final class AppShellState extends Equatable {
  const AppShellState({
    required this.identity,
    required this.sections,
    required this.footerLinks,
    required this.chrome,
  });

  factory AppShellState.from(SiteContent content) {
    return AppShellState(
      identity: content.identity,
      sections: content.sections,
      footerLinks: content.footerLinks,
      chrome: content.chrome,
    );
  }

  final SiteIdentity identity;
  final List<SiteSection> sections;
  final List<FooterLink> footerLinks;
  final ChromeContent chrome;

  @override
  List<Object?> get props => [identity, sections, footerLinks, chrome];
}
