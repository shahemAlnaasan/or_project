part of 'exchange_bloc.dart';

sealed class ExchangeEvent extends Equatable {
  const ExchangeEvent();

  @override
  List<Object> get props => [];
}

class GetPricesEvent extends ExchangeEvent {}

class NewExchangeEvent extends ExchangeEvent {
  final NewExchangeParams params;

  const NewExchangeEvent({required this.params});
}
