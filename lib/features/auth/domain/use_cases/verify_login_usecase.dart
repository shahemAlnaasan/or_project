import '../../../../common/consts/typedef.dart';
import '../../data/models/verify_login_response.dart';
import '../repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class VerifyLoginUsecase {
  final AuthRepository authRepository;

  VerifyLoginUsecase({required this.authRepository});

  DataResponse<VerifyLoginResponse> call({required VerifyLoginParams verifyLoginParams}) {
    return authRepository.verifylogin(verifyLoginParams: verifyLoginParams);
  }
}

class VerifyLoginParams with Params {
  final String username;
  final String password;
  final String id;
  final String deviceInfo;
  final String ipInfo;
  final String code;

  VerifyLoginParams({
    required this.username,
    required this.password,
    required this.id,
    required this.deviceInfo,
    required this.ipInfo,
    required this.code,
  });

  @override
  BodyMap getBody() => {
    "username": username,
    "password": password,
    "id": id,
    "device_info": deviceInfo,
    "ip_info": ipInfo,
    "code": code,
  };
}
