import '../../../../common/consts/typedef.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/verify_login_response.dart';
import '../use_cases/login_usecase.dart';
import '../use_cases/verify_login_usecase.dart';

abstract class AuthRepository {
  DataResponse<LoginResponseModel> login({required LoginParams loginParams});
  DataResponse<VerifyLoginResponse> verifylogin({required VerifyLoginParams verifyLoginParams});
}
