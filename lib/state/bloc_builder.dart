import 'package:bloc/bloc.dart';
import 'package:jaspr/jaspr.dart';

import 'bloc_provider.dart';

/// Builds a component from the bloc's current state.
typedef BlocStateBuilder<S> = Component Function(BuildContext context, S state);

/// Rebuilds [builder] whenever the bloc of type [B] emits.
///
/// **On this site the server tree emits exactly once and never re-emits.** The pages are built with
/// `mode: static`, so every section is rendered during `jaspr build` and frozen into HTML; a bloc
/// behind a section has no second state to deliver. The builder is used across the whole tree
/// anyway, so one convention covers both the frozen sections and the two hydrated islands, where
/// re-emission is real.
///
/// That is also why [stream] is handed to Jaspr's [StreamBuilder] only under [kIsWeb].
/// `StreamBuilderBase` asserts the stream is null on the server — subscribing there would schedule
/// rebuilds the static renderer does not allow. [kIsWeb] is a `bool.fromEnvironment` constant, so
/// the server build drops the subscription at compile time rather than skipping it at runtime.
final class BlocBuilder<B extends BlocBase<S>, S> extends StatelessComponent {
  const BlocBuilder({required this.builder, this.bloc, super.key});

  final BlocStateBuilder<S> builder;

  /// The bloc to watch. Read from the nearest [BlocProvider] when omitted, which is what the
  /// sections do; the islands pass their own instance from `get_it`.
  final B? bloc;

  @override
  Component build(BuildContext context) {
    final effectiveBloc = bloc ?? context.read<B>();

    return StreamBuilder<S>(
      initialData: effectiveBloc.state,
      stream: kIsWeb ? effectiveBloc.stream : null,
      builder: (context, snapshot) => builder(context, snapshot.requireData),
    );
  }
}
