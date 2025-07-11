part of 'credit_bloc.dart';

enum CreditStatus { initial, loading, success, failure }

class CreditState extends Equatable {
  final CreditStatus? status;
  final String? errorMessage;
  final List<OutgoingCreditResponse>? outgoingCredits;
  final List<IncomingCreditsResponse>? incomingCredits;
  final String? fromDate;
  final String? toDate;
  const CreditState({
    this.fromDate,
    this.toDate,
    this.status,
    this.errorMessage,
    this.outgoingCredits = const [],
    this.incomingCredits = const [],
  });

  CreditState copyWith({
    CreditStatus? status,
    String? errorMessage,
    List<OutgoingCreditResponse>? outgoingCredits,
    List<IncomingCreditsResponse>? incomingCredits,
    String? fromDate,
    String? toDate,
  }) {
    return CreditState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      outgoingCredits: outgoingCredits ?? this.outgoingCredits,
      incomingCredits: incomingCredits ?? this.incomingCredits,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, outgoingCredits, incomingCredits, fromDate, toDate];
}
