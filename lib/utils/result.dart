import 'package:equatable/equatable.dart';

sealed class Result<S, F> extends Equatable {
  const Result();
}

final class Success<S, F> extends Result<S, F> {
  const Success(this.value);

  final S value;

  @override
  List<Object?> get props => [value];
}

final class Failure<S, F> extends Result<S, F> {
  const Failure(this.error);

  final F error;

  @override
  List<Object?> get props => [error];
}
