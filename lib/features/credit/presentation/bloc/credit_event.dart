part of 'credit_bloc.dart';

sealed class CreditEvent extends Equatable {
  const CreditEvent();

  @override
  List<Object> get props => [];
}

class GetOutgoingCreditsEvent extends CreditEvent {
  final OutgoingCreditParams params;

  const GetOutgoingCreditsEvent({required this.params});
}

class GetIncomingCreditsEvent extends CreditEvent {
  final IncomingCreditParams params;

  const GetIncomingCreditsEvent({required this.params});
}

class GetOutgoingCreditDetailsEvent extends CreditEvent {
  final TransDetailsParams params;

  const GetOutgoingCreditDetailsEvent({required this.params});
}

class GetIncomingCreditDetailsEvent extends CreditEvent {
  final TransDetailsParams params;
  final bool isForDialog;

  const GetIncomingCreditDetailsEvent({required this.params, this.isForDialog = true});
}

class GetNewCreditDetailsEvent extends CreditEvent {
  final TransDetailsParams params;

  const GetNewCreditDetailsEvent({required this.params});
}

class GetCompaniesEvent extends CreditEvent {}

class GetCreditTargetsEvent extends CreditEvent {
  final GetCreditTargetsParams params;

  const GetCreditTargetsEvent({required this.params});
}

class GetCreditTaxEvent extends CreditEvent {
  final GetCreditTaxParams params;

  const GetCreditTaxEvent({required this.params});
}

class NewCreditEvent extends CreditEvent {
  final NewCreditParams params;

  const NewCreditEvent({required this.params});
}

class GetCurrenciesEvent extends CreditEvent {}
