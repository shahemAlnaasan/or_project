part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final Status? status;
  final String? errorMessage;
  final String? key;
  final String? systemActive;
  final String? name;
  final String? trust;
  const AuthState({this.status, this.errorMessage, this.key, this.systemActive, this.trust, this.name});

  AuthState copyWith({
    Status? status,
    String? errorMessage,
    String? key,
    String? systemActive,
    String? trust,
    String? name,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      key: key ?? this.key,
      systemActive: systemActive ?? this.systemActive,
      trust: trust ?? this.trust,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, key, systemActive, trust, name];
}
