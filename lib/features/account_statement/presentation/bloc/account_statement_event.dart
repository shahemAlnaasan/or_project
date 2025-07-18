part of 'account_statement_bloc.dart';

sealed class AccountStatementEvent extends Equatable {
  const AccountStatementEvent();

  @override
  List<Object> get props => [];
}

class GetAccountStatementEvent extends AccountStatementEvent {
  final AccountStatementParams params;

  const GetAccountStatementEvent({required this.params});
}

class GetCurrenciesEvent extends AccountStatementEvent {}
