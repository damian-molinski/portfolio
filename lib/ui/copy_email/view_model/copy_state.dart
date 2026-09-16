import 'package:equatable/equatable.dart';

final class CopyState extends Equatable {
  const CopyState.idle() : isCopied = false;

  const CopyState.copied() : isCopied = true;
  
  final bool isCopied;

  @override
  List<Object?> get props => [isCopied];
}
