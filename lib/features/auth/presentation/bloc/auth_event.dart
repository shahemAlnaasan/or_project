part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final LoginParams params;

  const LoginEvent({required this.params});
}

class VerifyLoginEvent extends AuthEvent {
  final String code;

  const VerifyLoginEvent({required this.code});
}

class InitVerifyInfoEvent extends AuthEvent {}
