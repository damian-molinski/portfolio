import 'package:equatable/equatable.dart';

import '../data/site_content_repository.dart';

/// What [SiteContentCubit] holds.
///
/// One case, and deliberately so: [SiteContentRepository.load] reads `const` data and performs no
/// I/O, so there is no loading state the page can be in and no failure it can report. The hierarchy
/// is `sealed` rather than a single class so that a second case — a runtime content source, say —
/// arrives as an exhaustiveness error at every `switch` instead of a silent `null`.
sealed class SiteContentState extends Equatable {
  const SiteContentState();
}

/// The content, available from the first build onwards.
final class SiteContentLoaded extends SiteContentState {
  const SiteContentLoaded(this.content);

  final SiteContent content;

  @override
  List<Object?> get props => [content];
}
