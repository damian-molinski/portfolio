import 'package:equatable/equatable.dart';

/// Whether the copy button is showing its confirmation.
final class CopyState extends Equatable {
  const CopyState.idle() : isCopied = false;

  const CopyState.copied() : isCopied = true;

  /// True for the few seconds after a successful clipboard write.
  final bool isCopied;

  @override
  List<Object?> get props => [isCopied];
}
