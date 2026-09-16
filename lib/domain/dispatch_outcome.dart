import 'package:equatable/equatable.dart';

import '../utils/result.dart';

typedef DispatchOutcome = Result<DispatchReceipt, Exception>;

final class DispatchReceipt extends Equatable {
  const DispatchReceipt(this.statusCode);

  final int statusCode;

  @override
  List<Object?> get props => [statusCode];
}

sealed class DispatchException implements Exception {
  const DispatchException();
}

final class NetworkDispatchException extends DispatchException {
  const NetworkDispatchException();
}

final class RejectedDispatchException extends DispatchException {
  const RejectedDispatchException();
}

final class RateLimitedDispatchException extends DispatchException {
  const RateLimitedDispatchException();
}

final class MailerDispatchException extends DispatchException {
  const MailerDispatchException();
}
