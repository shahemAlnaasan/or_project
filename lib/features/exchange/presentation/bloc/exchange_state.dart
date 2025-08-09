part of 'exchange_bloc.dart';

class ExchangeState extends Equatable {
  final Status? getPricesStatus;
  final Status? newExchangeStatus;
  final String? errorMessage;
  final GetPricesResponse? getPricesResponse;
  final NewExchangeResponse? newExchangeResponse;
  const ExchangeState({
    this.getPricesStatus,
    this.errorMessage,
    this.getPricesResponse,
    this.newExchangeStatus,
    this.newExchangeResponse,
  });

  ExchangeState copyWith({
    Status? getPricesStatus,
    Status? newExchangeStatus,
    String? errorMessage,
    GetPricesResponse? getPricesResponse,
    NewExchangeResponse? newExchangeResponse,
  }) {
    return ExchangeState(
      getPricesStatus: getPricesStatus ?? this.getPricesStatus,
      newExchangeStatus: newExchangeStatus ?? this.newExchangeStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      getPricesResponse: getPricesResponse ?? this.getPricesResponse,
      newExchangeResponse: newExchangeResponse ?? this.newExchangeResponse,
    );
  }

  @override
  List<Object?> get props => [getPricesStatus, newExchangeStatus, errorMessage, getPricesResponse, newExchangeResponse];
}
