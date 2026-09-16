import 'package:bloc/bloc.dart';
import 'package:jaspr/jaspr.dart';

import 'bloc_provider.dart';

typedef BlocStateBuilder<S> = Component Function(BuildContext context, S state);

final class BlocBuilder<B extends BlocBase<S>, S> extends StatelessComponent {
  const BlocBuilder({required this.builder, this.bloc, super.key});

  final BlocStateBuilder<S> builder;
  final B? bloc;

  @override
  Component build(BuildContext context) {
    final effectiveBloc = bloc ?? context.read<B>();

    return StreamBuilder<S>(
      initialData: effectiveBloc.state,
      // `StreamBuilderBase` asserts a null stream on the server, where subscribing would schedule
      // rebuilds the static renderer forbids.
      stream: kIsWeb ? effectiveBloc.stream : null,
      builder: (context, snapshot) => builder(context, snapshot.requireData),
    );
  }
}
