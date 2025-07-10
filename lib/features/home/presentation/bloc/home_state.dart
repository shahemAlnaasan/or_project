part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Status? status;
  final String? errorMessage;
  final AccountInfoResponse? accountInfo;
  const HomeState({this.status, this.errorMessage, this.accountInfo});

  HomeState copyWith({Status? status, String? errorMessage, AccountInfoResponse? accountInfo}) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      accountInfo: accountInfo ?? this.accountInfo,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, accountInfo];
}
