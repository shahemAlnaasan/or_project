part of 'exchange_bloc.dart';

class ExchangeState extends Equatable {
  final Status? getPricesStatus;
  final String? errorMessage;
  final GetPricesResponse? getPricesResponse;
  const ExchangeState({this.getPricesStatus, this.errorMessage, this.getPricesResponse});

  ExchangeState copyWith({Status? getPricesStatus, String? errorMessage, GetPricesResponse? getPricesResponse}) {
    return ExchangeState(
      getPricesStatus: getPricesStatus ?? this.getPricesStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      getPricesResponse: getPricesResponse ?? this.getPricesResponse,
    );
  }

  @override
  List<Object?> get props => [getPricesStatus, errorMessage, getPricesResponse];
}
