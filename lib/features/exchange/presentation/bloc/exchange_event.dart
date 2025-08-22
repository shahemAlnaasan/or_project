part of 'exchange_bloc.dart';

sealed class ExchangeEvent extends Equatable {
  const ExchangeEvent();

  @override
  List<Object> get props => [];
}

class GetPricesEvent extends ExchangeEvent {
  final bool isUpdateData;

  const GetPricesEvent({this.isUpdateData = false});
}

class NewExchangeEvent extends ExchangeEvent {
  final NewExchangeParams params;

  const NewExchangeEvent({required this.params});
}

class GetSenderCursEvent extends ExchangeEvent {}
