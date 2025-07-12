part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Status? homeStatus;
  final Status? currenciesStatus;
  final String? errorMessage;
  final AccountInfoResponse? accountInfo;
  final CurrenciesResponse? currencies;

  const HomeState({this.homeStatus, this.errorMessage, this.accountInfo, this.currencies, this.currenciesStatus});

  HomeState copyWith({
    Status? homeStatus,
    Status? currenciesStatus,
    String? errorMessage,
    AccountInfoResponse? accountInfo,
    CurrenciesResponse? currencies,
  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      currenciesStatus: currenciesStatus ?? this.currenciesStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      accountInfo: accountInfo ?? this.accountInfo,
      currencies: currencies ?? this.currencies,
    );
  }

  @override
  List<Object?> get props => [homeStatus, errorMessage, accountInfo, currencies, currenciesStatus];
}
