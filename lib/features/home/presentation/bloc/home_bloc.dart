import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golder_octopus/common/consts/app_keys.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/core/datasources/hive_helper.dart';
import 'package:golder_octopus/features/account_statement/data/models/currencies_response.dart';
import 'package:golder_octopus/features/auth/data/models/login_response_model.dart';
import 'package:golder_octopus/features/home/data/models/account_info_response.dart';
import 'package:golder_octopus/features/home/domain/use_cases/account_info_usecase.dart';
import 'package:golder_octopus/features/transfer/data/models/get_trans_targets_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_trans_targets_usecase.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AccountInfoUsecase accountInfoUsecase;
  final GetTransTargetsUsecase getTransTargetsUsecase;

  HomeBloc({required this.accountInfoUsecase, required this.getTransTargetsUsecase}) : super(HomeState()) {
    on<GetAccountInfoEvent>(_onGetAccountInfoEvent);
    on<GetTransTargetsEvent>(_onGetTransTargetsEvent);
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

  Future<void> _onGetTransTargetsEvent(GetTransTargetsEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(getTransTargetsStatus: Status.loading));
    final LoginResponseModel loginResponseModel = await HiveHelper.getFromHive(
      boxName: AppKeys.userBox,
      key: AppKeys.loginResponse,
    );

    final String userId = loginResponseModel.id;
    GetTransTargetsParams params = GetTransTargetsParams(userId: userId);

    final result = await getTransTargetsUsecase(params: params);

    result.fold(
      (left) {
        emit(state.copyWith(getTransTargetsStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getTransTargetsStatus: Status.success, transTargetsResponse: right));
      },
    );
  }
}
