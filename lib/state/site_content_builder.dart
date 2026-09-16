import 'package:jaspr/jaspr.dart';

import '../data/site_content_repository.dart';
import 'bloc_builder.dart';
import 'site_content_cubit.dart';
import 'site_content_state.dart';

typedef SiteContentWidgetBuilder = Component Function(BuildContext context, SiteContent content);

final class SiteContentBuilder extends StatelessComponent {
  const SiteContentBuilder({required this.builder, this.cubit, super.key});

  final SiteContentWidgetBuilder builder;
  final SiteContentCubit? cubit;

  @override
  Component build(BuildContext context) {
    return BlocBuilder<SiteContentCubit, SiteContentState>(
      bloc: cubit,
      builder: (context, state) => builder(context, state.content),
    );
  }
}
