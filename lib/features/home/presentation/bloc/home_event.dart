part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetAccountInfoEvent extends HomeEvent {}

class GetTransTargetsEvent extends HomeEvent {}
