import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:golder_octopus/features/auth/data/models/login_response_model.dart';
import 'package:golder_octopus/features/auth/data/models/verify_login_response.dart';
import 'package:golder_octopus/features/auth/domain/repositories/auth_repository.dart';
import 'package:golder_octopus/features/auth/domain/use_cases/login_usecase.dart';
import 'package:golder_octopus/features/auth/domain/use_cases/verify_login_usecase.dart';
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
