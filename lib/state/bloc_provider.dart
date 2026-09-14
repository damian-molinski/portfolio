import 'package:bloc/bloc.dart';
import 'package:jaspr/jaspr.dart';

/// Builds the bloc a [BlocProvider] owns, from the context it is mounted in.
typedef BlocCreate<B extends BlocBase<Object?>> = B Function(BuildContext context);

/// Wraps a component so its descendants can receive [child] unchanged.
///
/// Each entry in [MultiBlocProvider.providers] has this shape.
typedef ComponentWrapper = Component Function(Component child);

/// Puts a bloc in the tree for descendants to read with `context.read<B>()`.
///
/// The default constructor owns what it creates and closes it on dispose;
/// [BlocProvider.value] takes an instance someone else owns and leaves it open.
///
/// Only the pre-rendered tree under `App` uses this. The two `@client` islands hydrate as separate
/// trees and cannot see anything provided above them, so they resolve their blocs from `get_it`
/// instead — see `lib/di/injector.dart`.
final class BlocProvider<B extends BlocBase<Object?>> extends StatefulComponent {
  const BlocProvider({
    required BlocCreate<B> create,
    required this.child,
    super.key,
  }) : _create = create,
       _value = null;

  /// Provides an already-constructed [value] without taking ownership of it.
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

  /// False for [BlocProvider.value], where closing would pull the bloc out from under its owner.
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

/// The inherited half of [BlocProvider]. Split out because [InheritedComponent] has no dispose
/// hook, and the bloc has to be closed somewhere.
class _BlocScope<B extends BlocBase<Object?>> extends InheritedComponent {
  const _BlocScope({required this.bloc, required super.child});

  final B bloc;

  @override
  bool updateShouldNotify(_BlocScope<B> oldComponent) => bloc != oldComponent.bloc;
}

/// Nests several providers around one [child] without the indentation that writing them out would
/// cost. The first entry ends up outermost.
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
  /// The nearest bloc of type [B].
  ///
  /// Throws a [StateError] when no [BlocProvider] of that type is an ancestor, because a missing
  /// provider is a wiring mistake and a null would only surface further away from it.
  B read<B extends BlocBase<Object?>>() {
    final scope = dependOnInheritedComponentOfExactType<_BlocScope<B>>();
    if (scope == null) {
      throw StateError('No BlocProvider<$B> found above this context.');
    }
    return scope.bloc;
  }
}
