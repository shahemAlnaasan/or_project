part of 'account_statement_bloc.dart';

enum AcccountStmtStatus { initial, loading, success, failure }

class AccountStatementState extends Equatable {
  final AcccountStmtStatus? status;
  final String? errorMessage;
  final AccountStatementResponse? accountStatement;
  final String? fromDate;
  final String? toDate;
  const AccountStatementState({this.fromDate, this.toDate, this.status, this.errorMessage, this.accountStatement});

  AccountStatementState copyWith({
    AcccountStmtStatus? status,
    String? errorMessage,
    AccountStatementResponse? accountStatement,
    String? fromDate,
    String? toDate,
  }) {
    return AccountStatementState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      accountStatement: accountStatement ?? this.accountStatement,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, accountStatement, fromDate, toDate];
}
