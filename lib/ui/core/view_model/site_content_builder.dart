import 'package:jaspr/jaspr.dart';

import '../../../domain/models/site_content.dart';
import '../binding/bloc_builder.dart';
import 'site_content_state.dart';
import 'site_content_view_model.dart';

typedef SiteContentWidgetBuilder = Component Function(BuildContext context, SiteContent content);

final class SiteContentBuilder extends StatelessComponent {
  const SiteContentBuilder({required this.builder, this.cubit, super.key});

  final SiteContentWidgetBuilder builder;
  final SiteContentViewModel? cubit;

  @override
  Component build(BuildContext context) {
    return BlocBuilder<SiteContentViewModel, SiteContentState>(
      bloc: cubit,
      builder: (context, state) => builder(context, state.content),
    );
  }
}
