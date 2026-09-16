import 'package:equatable/equatable.dart';

import '../../../domain/models/site_content.dart';

final class SiteContentState extends Equatable {
  const SiteContentState(this.content);

  final SiteContent content;

  @override
  List<Object?> get props => [content];
}
