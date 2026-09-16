import 'package:bloc/bloc.dart';
import 'package:jaspr/jaspr.dart';

typedef BlocCreate<B extends BlocBase<Object?>> = B Function(BuildContext context);

typedef ComponentWrapper = Component Function(Component child);

final class BlocProvider<B extends BlocBase<Object?>> extends StatefulComponent {
  const BlocProvider({
    required BlocCreate<B> create,
    required this.child,
    super.key,
  }) : _create = create,
       _value = null;
  const BlocProvider.value({
    required B value,
    required this.child,
    super.key,
  }) : _value = value,
       _create = null;

  final BlocCreate<B>? _create;
  final B? _value;
  final Component child;

  @override
  State<BlocProvider<B>> createState() => _BlocProviderState<B>();
}

class _BlocProviderState<B extends BlocBase<Object?>> extends State<BlocProvider<B>> {
  late final B _bloc;
  late final bool _ownsBloc;

  @override
  void initState() {
    super.initState();

    final providedBloc = component._value;
    _ownsBloc = providedBloc == null;
    _bloc = providedBloc ?? component._create!(context);
  }

  @override
  void dispose() {
    if (_ownsBloc) _bloc.close();
    super.dispose();
  }

  @override
  Component build(BuildContext context) => _BlocScope<B>(bloc: _bloc, child: component.child);
}

class _BlocScope<B extends BlocBase<Object?>> extends InheritedComponent {
  const _BlocScope({required this.bloc, required super.child});

  final B bloc;

  @override
  bool updateShouldNotify(_BlocScope<B> oldComponent) => bloc != oldComponent.bloc;
}

final class MultiBlocProvider extends StatelessComponent {
  const MultiBlocProvider({required this.providers, required this.child, super.key});

  final List<ComponentWrapper> providers;
  final Component child;

  @override
  Component build(BuildContext context) {
    return providers.reversed.fold(child, (wrapped, provider) => provider(wrapped));
  }
}

extension BlocContext on BuildContext {
  B read<B extends BlocBase<Object?>>() {
    final scope = dependOnInheritedComponentOfExactType<_BlocScope<B>>();
    if (scope == null) {
      throw StateError('No BlocProvider<$B> found above this context.');
    }
    return scope.bloc;
  }
}
