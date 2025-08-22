part of 'credit_bloc.dart';

class CreditState extends Equatable {
  final Status? getOutgoingCreditsStatus;
  final Status? getIncomingCreditsStatus;
  final Status? outgoingCreditDetailsStatus;
  final Status? incomingCreditDetailsStatus;
  final Status? newCreditDetailsStatus;

  final Status? getCompaniesStatus;
  final Status? getCreditTargetsStatus;
  final Status? getCreditTaxStatus;
  final Status? newCreditStatus;
  final Status? getCurreciesStatus;
  final Status? getSenderCursStatus;

  final String? errorMessage;
  final List<OutgoingCreditResponse>? outgoingCredits;
  final List<IncomingCreditsResponse>? incomingCredits;
  final TransDetailsResponse? creditDetailsResponse;
  final CurrenciesResponse? currenciesResponse;

  final GetCompaniesResponse? getCompaniesResponse;
  final GetCreditTargetsResponse? getCreditTargetsResponse;
  final GetCreditTaxResponse? getCreditTaxResponse;
  final NewCreditResponse? newCreditResponse;
  final GetSenderCursResponse? getSenderCursResponse;

  final bool isForDialog;

  final String? fromDate;
  final String? toDate;
  const CreditState({
    this.fromDate,
    this.toDate,
    this.outgoingCreditDetailsStatus,
    this.incomingCreditDetailsStatus,
    this.newCreditDetailsStatus,
    this.getOutgoingCreditsStatus,
    this.getIncomingCreditsStatus,
    this.currenciesResponse,
    this.getCompaniesStatus,
    this.getCreditTargetsStatus,
    this.getCreditTaxStatus,
    this.newCreditStatus,
    this.getCurreciesStatus,
    this.getSenderCursStatus,

    this.isForDialog = true,
    this.errorMessage,
    this.outgoingCredits = const [],
    this.incomingCredits = const [],
    this.creditDetailsResponse,
    this.getCompaniesResponse,
    this.getCreditTargetsResponse,
    this.getCreditTaxResponse,
    this.newCreditResponse,
    this.getSenderCursResponse,
  });

  CreditState copyWith({
    String? errorMessage,
    Status? outgoingCreditDetailsStatus,
    Status? incomingCreditDetailsStatus,
    Status? newCreditDetailsStatus,

    Status? getOutgoingCreditsStatus,
    Status? getIncomingCreditsStatus,

    Status? getCompaniesStatus,
    Status? getCreditTargetsStatus,
    Status? getCreditTaxStatus,
    Status? newCreditStatus,
    Status? getCurreciesStatus,
    Status? getSenderCursStatus,

    bool? isForDialog,
    List<OutgoingCreditResponse>? outgoingCredits,
    List<IncomingCreditsResponse>? incomingCredits,
    TransDetailsResponse? creditDetailsResponse,

    GetCompaniesResponse? getCompaniesResponse,
    GetCreditTargetsResponse? getCreditTargetsResponse,
    GetCreditTaxResponse? getCreditTaxResponse,
    NewCreditResponse? newCreditResponse,
    CurrenciesResponse? currenciesResponse,
    GetSenderCursResponse? getSenderCursResponse,

    String? fromDate,
    String? toDate,
  }) {
    return CreditState(
      outgoingCreditDetailsStatus: outgoingCreditDetailsStatus ?? this.outgoingCreditDetailsStatus,
      incomingCreditDetailsStatus: incomingCreditDetailsStatus ?? this.incomingCreditDetailsStatus,
      newCreditDetailsStatus: newCreditDetailsStatus ?? this.newCreditDetailsStatus,
      getOutgoingCreditsStatus: getOutgoingCreditsStatus ?? this.getOutgoingCreditsStatus,
      getIncomingCreditsStatus: getIncomingCreditsStatus ?? this.getIncomingCreditsStatus,
      getCompaniesStatus: getCompaniesStatus ?? this.getCompaniesStatus,
      getCreditTargetsStatus: getCreditTargetsStatus ?? this.getCreditTargetsStatus,
      getCreditTaxStatus: getCreditTaxStatus ?? this.getCreditTaxStatus,
      newCreditStatus: newCreditStatus ?? this.newCreditStatus,
      getCurreciesStatus: getCurreciesStatus ?? this.getCurreciesStatus,
      getSenderCursStatus: getSenderCursStatus ?? this.getSenderCursStatus,

      isForDialog: isForDialog ?? this.isForDialog,
      errorMessage: errorMessage ?? this.errorMessage,
      outgoingCredits: outgoingCredits ?? this.outgoingCredits,
      incomingCredits: incomingCredits ?? this.incomingCredits,
      creditDetailsResponse: creditDetailsResponse ?? this.creditDetailsResponse,
      getCompaniesResponse: getCompaniesResponse ?? this.getCompaniesResponse,
      getCreditTargetsResponse: getCreditTargetsResponse ?? this.getCreditTargetsResponse,
      getCreditTaxResponse: getCreditTaxResponse ?? this.getCreditTaxResponse,
      newCreditResponse: newCreditResponse ?? this.newCreditResponse,
      currenciesResponse: currenciesResponse ?? this.currenciesResponse,
      getSenderCursResponse: getSenderCursResponse ?? this.getSenderCursResponse,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [
    outgoingCreditDetailsStatus,
    incomingCreditDetailsStatus,
    newCreditDetailsStatus,
    getOutgoingCreditsStatus,
    getIncomingCreditsStatus,
    getCompaniesStatus,
    getCreditTargetsStatus,
    getCreditTaxStatus,
    newCreditStatus,
    getCurreciesStatus,
    getSenderCursStatus,
    isForDialog,
    errorMessage,
    outgoingCredits,
    incomingCredits,
    creditDetailsResponse,
    getCompaniesResponse,
    getCreditTargetsResponse,
    getCreditTaxResponse,
    newCreditResponse,
    currenciesResponse,
    getSenderCursResponse,
    fromDate,
    toDate,
  ];
}
