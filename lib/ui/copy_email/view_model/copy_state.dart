import 'package:equatable/equatable.dart';

final class CopyState extends Equatable {
  const CopyState.idle({
    required this.email,
    required this.label,
    required this.successLabel,
    required this.ariaLabel,
  }) : isCopied = false;

  const CopyState._({
    required this.isCopied,
    required this.email,
    required this.label,
    required this.successLabel,
    required this.ariaLabel,
  });

  final bool isCopied;
  final String email;
  final String label;
  final String successLabel;
  final String ariaLabel;

  CopyState confirmed() => _withCopied(isCopied: true);

  CopyState reverted() => _withCopied(isCopied: false);

  CopyState _withCopied({required bool isCopied}) {
    return CopyState._(
      isCopied: isCopied,
      email: email,
      label: label,
      successLabel: successLabel,
      ariaLabel: ariaLabel,
    );
  }

  @override
  List<Object?> get props => [isCopied, email, label, successLabel, ariaLabel];
}
