part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Status? homeStatus;
  final Status? currenciesStatus;
  final Status? getTransTargetsStatus;
  final String? errorMessage;
  final AccountInfoResponse? accountInfo;
  final CurrenciesResponse? currencies;
  final GetTransTargetsResponse? transTargetsResponse;

  const HomeState({
    this.homeStatus,
    this.errorMessage,
    this.accountInfo,
    this.currencies,
    this.currenciesStatus,
    this.getTransTargetsStatus,
    this.transTargetsResponse,
  });

  HomeState copyWith({
    Status? homeStatus,
    Status? currenciesStatus,
    Status? getTransTargetsStatus,
    String? errorMessage,
    AccountInfoResponse? accountInfo,
    CurrenciesResponse? currencies,
    GetTransTargetsResponse? transTargetsResponse,
  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      getTransTargetsStatus: getTransTargetsStatus ?? this.getTransTargetsStatus,
      currenciesStatus: currenciesStatus ?? this.currenciesStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      accountInfo: accountInfo ?? this.accountInfo,
      currencies: currencies ?? this.currencies,
      transTargetsResponse: transTargetsResponse ?? this.transTargetsResponse,
    );
  }

  @override
  List<Object?> get props => [
    homeStatus,
    errorMessage,
    accountInfo,
    currencies,
    currenciesStatus,
    getTransTargetsStatus,
    transTargetsResponse,
  ];
}
