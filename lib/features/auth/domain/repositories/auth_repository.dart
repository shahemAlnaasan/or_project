import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/auth/data/models/login_response_model.dart';
import 'package:golder_octopus/features/auth/data/models/verify_login_response.dart';
import 'package:golder_octopus/features/auth/domain/use_cases/login_usecase.dart';
import 'package:golder_octopus/features/auth/domain/use_cases/verify_login_usecase.dart';

abstract class AuthRepository {
  DataResponse<LoginResponseModel> login({required LoginParams loginParams});
  DataResponse<VerifyLoginResponse> verifylogin({required VerifyLoginParams verifyLoginParams});
}
