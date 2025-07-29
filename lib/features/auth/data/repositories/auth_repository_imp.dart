import '../../../../common/consts/typedef.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_response_model.dart';
import '../models/verify_login_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login_usecase.dart';
import '../../domain/use_cases/verify_login_usecase.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImp({required this.authRemoteDataSource});
  @override
  DataResponse<LoginResponseModel> login({required LoginParams loginParams}) {
    return authRemoteDataSource.login(params: loginParams);
  }

  @override
  DataResponse<VerifyLoginResponse> verifylogin({required VerifyLoginParams verifyLoginParams}) {
    return authRemoteDataSource.verifyLogin(params: verifyLoginParams);
  }
}
