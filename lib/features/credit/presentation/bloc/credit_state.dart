part of 'credit_bloc.dart';

enum CreditStatus { initial, loading, success, failure }

class CreditState extends Equatable {
  final CreditStatus? status;
  final Status? outgoingCreditDetailsStatus;
  final Status? incomingCreditDetailsStatus;

  final String? errorMessage;
  final List<OutgoingCreditResponse>? outgoingCredits;
  final List<IncomingCreditsResponse>? incomingCredits;
  final TransDetailsResponse? outgoingCreditDetailsResponse;
  final TransDetailsResponse? incomingCreditDetailsResponse;

  final bool isForDialog;

  final String? fromDate;
  final String? toDate;
  const CreditState({
    this.fromDate,
    this.toDate,
    this.status,
    this.outgoingCreditDetailsStatus,
    this.incomingCreditDetailsStatus,
    this.isForDialog = true,
    this.errorMessage,
    this.outgoingCredits = const [],
    this.incomingCredits = const [],
    this.outgoingCreditDetailsResponse,
    this.incomingCreditDetailsResponse,
  });

  CreditState copyWith({
    CreditStatus? status,
    String? errorMessage,
    Status? outgoingCreditDetailsStatus,
    Status? incomingCreditDetailsStatus,
    bool? isForDialog,
    List<OutgoingCreditResponse>? outgoingCredits,
    List<IncomingCreditsResponse>? incomingCredits,
    TransDetailsResponse? outgoingCreditDetailsResponse,
    TransDetailsResponse? incomingCreditDetailsResponse,
    String? fromDate,
    String? toDate,
  }) {
    return CreditState(
      outgoingCreditDetailsStatus: outgoingCreditDetailsStatus ?? this.outgoingCreditDetailsStatus,
      incomingCreditDetailsStatus: incomingCreditDetailsStatus ?? this.incomingCreditDetailsStatus,
      isForDialog: isForDialog ?? this.isForDialog,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      outgoingCredits: outgoingCredits ?? this.outgoingCredits,
      incomingCredits: incomingCredits ?? this.incomingCredits,
      outgoingCreditDetailsResponse: outgoingCreditDetailsResponse ?? this.outgoingCreditDetailsResponse,
      incomingCreditDetailsResponse: incomingCreditDetailsResponse ?? this.incomingCreditDetailsResponse,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [
    status,
    outgoingCreditDetailsStatus,
    incomingCreditDetailsStatus,
    isForDialog,
    errorMessage,
    outgoingCredits,
    incomingCredits,
    outgoingCreditDetailsResponse,
    incomingCreditDetailsResponse,
    fromDate,
    toDate,
  ];
}
