import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/features/account_statement/data/models/currencies_response.dart';
import 'package:golder_octopus/features/home/data/models/account_info_response.dart';
import 'package:golder_octopus/features/home/domain/use_cases/account_info_usecase.dart';
import 'package:golder_octopus/features/home/domain/use_cases/currencies_usecase.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AccountInfoUsecase accountInfoUsecase;
  final CurrenciesUsecase currenciesUsecase;

  HomeBloc({required this.accountInfoUsecase, required this.currenciesUsecase}) : super(HomeState()) {
    on<GetAccountInfoEvent>(_onGetAccountInfoEvent);
    on<GetCurrenciesEvent>(_onGetCurrenciesEvent);
  }

  Future<void> _onGetAccountInfoEvent(GetAccountInfoEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(homeStatus: Status.loading));
    final result = await accountInfoUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(homeStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(homeStatus: Status.success, accountInfo: right));
      },
    );
  }

  Future<void> _onGetCurrenciesEvent(GetCurrenciesEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(currenciesStatus: Status.loading));
    final result = await currenciesUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(currenciesStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(currenciesStatus: Status.success, currencies: right));
      },
    );
  }
}
