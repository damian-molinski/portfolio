import 'package:jaspr/jaspr.dart';

import '../data/site_content_repository.dart';
import 'bloc_builder.dart';
import 'site_content_cubit.dart';
import 'site_content_state.dart';

/// Builds a component from the site's copy.
typedef SiteContentWidgetBuilder = Component Function(BuildContext context, SiteContent content);

/// Hands [builder] the site's copy, from the nearest [SiteContentCubit].
///
/// Every section on the page reads its copy through this, including the ones that freeze at build
/// time — one convention covers the pre-rendered tree and the two hydrated islands alike. It is
/// [BlocBuilder] with the state unwrapped, because no caller has ever wanted [SiteContentState]
/// itself: the state carries one field.
final class SiteContentBuilder extends StatelessComponent {
  const SiteContentBuilder({required this.builder, this.cubit, super.key});

  final SiteContentWidgetBuilder builder;

  /// The cubit to read. Omitted by the sections, which find it in the [BlocProvider] above `App`;
  /// the two islands hydrate as their own trees and pass the instance they resolved from `get_it`.
  final SiteContentCubit? cubit;

  @override
  Component build(BuildContext context) {
    return BlocBuilder<SiteContentCubit, SiteContentState>(
      bloc: cubit,
      builder: (context, state) => builder(context, state.content),
    );
  }
}
