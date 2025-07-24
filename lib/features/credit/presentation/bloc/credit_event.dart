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
