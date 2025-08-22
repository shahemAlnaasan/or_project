part of 'exchange_bloc.dart';

class ExchangeState extends Equatable {
  final Status? getPricesStatus;
  final Status? newExchangeStatus;
  final Status? getSenderCursStatus;

  final String? errorMessage;
  final bool isUpdatePrices;
  final GetPricesResponse? getPricesResponse;
  final NewExchangeResponse? newExchangeResponse;
  final GetSenderCursResponse? getSenderCursResponse;

  const ExchangeState({
    this.getPricesStatus,
    this.errorMessage,
    this.getSenderCursStatus,
    this.getSenderCursResponse,
    this.isUpdatePrices = false,
    this.getPricesResponse,
    this.newExchangeStatus,
    this.newExchangeResponse,
  });

  ExchangeState copyWith({
    Status? getPricesStatus,
    Status? newExchangeStatus,
    Status? getSenderCursStatus,
    String? errorMessage,
    bool? isUpdatePrices,
    GetPricesResponse? getPricesResponse,
    NewExchangeResponse? newExchangeResponse,
    GetSenderCursResponse? getSenderCursResponse,
  }) {
    return ExchangeState(
      getPricesStatus: getPricesStatus ?? this.getPricesStatus,
      newExchangeStatus: newExchangeStatus ?? this.newExchangeStatus,
      getSenderCursStatus: getSenderCursStatus ?? this.getSenderCursStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdatePrices: isUpdatePrices ?? this.isUpdatePrices,
      getPricesResponse: getPricesResponse ?? this.getPricesResponse,
      newExchangeResponse: newExchangeResponse ?? this.newExchangeResponse,
      getSenderCursResponse: getSenderCursResponse ?? this.getSenderCursResponse,
    );
  }

  @override
  List<Object?> get props => [
    getPricesStatus,
    newExchangeStatus,
    getSenderCursStatus,
    errorMessage,
    isUpdatePrices,
    getPricesResponse,
    newExchangeResponse,
    getSenderCursResponse,
  ];
}
