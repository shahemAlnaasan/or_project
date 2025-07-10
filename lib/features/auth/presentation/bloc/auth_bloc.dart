import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golder_octopus/common/consts/app_keys.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/common/utils/device_info.dart';
import 'package:golder_octopus/core/datasources/hive_helper.dart';
import 'package:golder_octopus/features/auth/data/models/login_response_model.dart';
import 'package:golder_octopus/features/auth/domain/use_cases/login_usecase.dart';
import 'package:golder_octopus/features/auth/domain/use_cases/verify_login_usecase.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final VerifyLoginUsecase verifyLoginUsecase;
  AuthBloc({required this.loginUsecase, required this.verifyLoginUsecase}) : super(AuthState()) {
    on<LoginEvent>(_onLoginEvent);
    on<VerifyLoginEvent>(_onVerifyLoginEvent);
    on<InitVerifyInfoEvent>(_onInitVerifyInfoEvent);
  }
  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final String deviceType = await DeviceInfo.deviceType();
    final String? deviceIp = await DeviceInfo.getDeviceIp();
    if (deviceIp != null) {
      final LoginParams params = LoginParams(
        username: event.params.username,
        password: event.params.password,
        ipInfo: deviceIp,
        deviceInfo: deviceType,
      );

      final result = await loginUsecase(loginParams: params);
      result.fold(
        (left) {
          emit(state.copyWith(status: Status.failure, errorMessage: left.message));
        },
        (right) {
          if (right.systemActive == "true") {
            HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.loginParams, value: params);
            HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.loginResponse, value: right);
            HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.hasLogin, value: true);
            emit(
              state.copyWith(
                status: Status.success,
                key: right.authkey,
                systemActive: right.systemActive,
                trust: right.trust,
                name: right.name,
              ),
            );
          } else {
            emit(state.copyWith(status: Status.failure, errorMessage: "النظام معطل"));
          }
        },
      );
    } else {
      emit(state.copyWith(status: Status.failure, errorMessage: "خطأ بالاتصال"));
    }
  }

  Future<void> _onVerifyLoginEvent(VerifyLoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final LoginParams loginparams = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.loginParams);
    final LoginResponseModel loginResponseModel = await HiveHelper.getFromHive(
      boxName: AppKeys.userBox,
      key: AppKeys.loginResponse,
    );

    final String userId = loginResponseModel.id;

    final VerifyLoginParams verifyLoginParams = VerifyLoginParams(
      username: loginparams.username,
      password: loginparams.password,
      id: userId,
      deviceInfo: loginparams.deviceInfo,
      ipInfo: loginparams.ipInfo,
      code: event.code,
    );
    final result = await verifyLoginUsecase(verifyLoginParams: verifyLoginParams);
    result.fold(
      (left) {
        emit(state.copyWith(status: Status.failure, errorMessage: left.message));
      },
      (right) {
        HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.hasVerifyLogin, value: true);
        HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.tokenKey, value: right.token);
        emit(state.copyWith(status: Status.success));
      },
    );
  }

  Future<void> _onInitVerifyInfoEvent(InitVerifyInfoEvent event, Emitter<AuthState> emit) async {
    final LoginResponseModel loginResponseModel = await HiveHelper.getFromHive(
      boxName: AppKeys.userBox,
      key: AppKeys.loginResponse,
    );
    emit(
      state.copyWith(
        key: loginResponseModel.authkey,
        systemActive: loginResponseModel.systemActive,
        trust: loginResponseModel.trust,
        name: loginResponseModel.name,
      ),
    );
  }
}
