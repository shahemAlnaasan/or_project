import '../../../../common/consts/typedef.dart';
import '../../data/models/login_response_model.dart';
import '../repositories/auth_repository.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUsecase {
  final AuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  DataResponse<LoginResponseModel> call({required LoginParams loginParams}) {
    return authRepository.login(loginParams: loginParams);
  }
}

class LoginParams extends HiveObject with Params {
  final String username;
  final String password;
  final String ipInfo;
  final String deviceInfo;

  LoginParams({required this.username, required this.password, required this.ipInfo, required this.deviceInfo});

  @override
  BodyMap getBody() => {"username": username, "password": password, "ip_info": ipInfo, "device_info": deviceInfo};
}
