part of 'account_statement_bloc.dart';

class AccountStatementState extends Equatable {
  final Status? accountStatmentStatus;
  final Status? getCurreciesStatus;
  final CurrenciesResponse? currenciesResponse;
  final String? errorMessage;
  final AccountStatementResponse? accountStatement;
  final String? fromDate;
  final String? toDate;
  const AccountStatementState({
    this.fromDate,
    this.toDate,
    this.accountStatmentStatus,
    this.getCurreciesStatus,
    this.currenciesResponse,
    this.errorMessage,
    this.accountStatement,
  });

  AccountStatementState copyWith({
    Status? accountStatmentStatus,
    String? errorMessage,
    Status? getCurreciesStatus,
    CurrenciesResponse? currenciesResponse,
    AccountStatementResponse? accountStatement,
    String? fromDate,
    String? toDate,
  }) {
    return AccountStatementState(
      accountStatmentStatus: accountStatmentStatus ?? this.accountStatmentStatus,
      getCurreciesStatus: getCurreciesStatus ?? this.getCurreciesStatus,
      currenciesResponse: currenciesResponse ?? this.currenciesResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      accountStatement: accountStatement ?? this.accountStatement,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [
    accountStatmentStatus,
    errorMessage,
    accountStatement,
    currenciesResponse,
    getCurreciesStatus,
    fromDate,
    toDate,
  ];
}
