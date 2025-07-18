part of 'account_statement_bloc.dart';

enum AcccountStmtStatus { initial, loading, success, failure }

class AccountStatementState extends Equatable {
  final AcccountStmtStatus? status;
  final Status? getCurreciesStatus;
  final CurrenciesResponse? currenciesResponse;
  final String? errorMessage;
  final AccountStatementResponse? accountStatement;
  final CurrenciesResponse? currencies;
  final String? fromDate;
  final String? toDate;
  const AccountStatementState({
    this.fromDate,
    this.toDate,
    this.status,
    this.getCurreciesStatus,
    this.currenciesResponse,
    this.errorMessage,
    this.accountStatement,
    this.currencies,
  });

  AccountStatementState copyWith({
    AcccountStmtStatus? status,
    String? errorMessage,
    Status? getCurreciesStatus,
    CurrenciesResponse? currenciesResponse,
    AccountStatementResponse? accountStatement,
    CurrenciesResponse? currencies,
    String? fromDate,
    String? toDate,
  }) {
    return AccountStatementState(
      status: status ?? this.status,
      getCurreciesStatus: getCurreciesStatus ?? this.getCurreciesStatus,
      currenciesResponse: currenciesResponse ?? this.currenciesResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      accountStatement: accountStatement ?? this.accountStatement,
      currencies: currencies ?? this.currencies,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    accountStatement,
    currencies,
    currenciesResponse,
    getCurreciesStatus,
    fromDate,
    toDate,
  ];
}
