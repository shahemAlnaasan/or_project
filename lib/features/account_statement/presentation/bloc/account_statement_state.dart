part of 'account_statement_bloc.dart';

enum AcccountStmtStatus { initial, loading, success, failure }

class AccountStatementState extends Equatable {
  final AcccountStmtStatus? status;
  final String? errorMessage;
  final AccountStatementResponse? accountStatement;
  final CurrenciesResponse? currencies;
  final String? fromDate;
  final String? toDate;
  const AccountStatementState({
    this.fromDate,
    this.toDate,
    this.status,
    this.errorMessage,
    this.accountStatement,
    this.currencies,
  });

  AccountStatementState copyWith({
    AcccountStmtStatus? status,
    String? errorMessage,
    AccountStatementResponse? accountStatement,
    CurrenciesResponse? currencies,
    String? fromDate,
    String? toDate,
  }) {
    return AccountStatementState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      accountStatement: accountStatement ?? this.accountStatement,
      currencies: currencies ?? this.currencies,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, accountStatement, currencies, fromDate, toDate];
}
