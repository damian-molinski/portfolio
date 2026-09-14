import 'package:equatable/equatable.dart';

import '../data/site_content_repository.dart';

/// What [SiteContentCubit] holds: the site's copy, available from the first build onwards.
///
/// One class rather than a `sealed` hierarchy. [SiteContentRepository.load] reads `const` data and
/// performs no I/O, so there is no loading state the page can be in and no failure it can report;
/// the hierarchy had exactly one member and every reader of it was a single-arm `switch` a reader
/// had to check said nothing.
///
/// What that gives up: a second case — a runtime content source, say — no longer arrives as an
/// exhaustiveness error at every call site. It becomes a breaking change to this class instead,
/// reported at the constructor rather than at each place that reads [content].
final class SiteContentState extends Equatable {
  const SiteContentState(this.content);

  final SiteContent content;

  @override
  List<Object?> get props => [content];
}
