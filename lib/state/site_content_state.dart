import 'package:equatable/equatable.dart';

import '../data/site_content_repository.dart';

final class SiteContentState extends Equatable {
  const SiteContentState(this.content);

  final SiteContent content;

  @override
  List<Object?> get props => [content];
}
