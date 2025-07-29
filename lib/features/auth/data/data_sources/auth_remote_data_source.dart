import 'package:dartz/dartz.dart';
import '../../../../core/config/endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../models/login_response_model.dart';
import '../models/verify_login_response.dart';
import '../../domain/use_cases/login_usecase.dart';
import '../../domain/use_cases/verify_login_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthRemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  AuthRemoteDataSource({required this.httpClient});

  Future<Either<Failure, LoginResponseModel>> login({required LoginParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.login, data: params.getBody()),
      fromJson: (json) => LoginResponseModel.fromJson(json),
    );
  }

  Future<Either<Failure, VerifyLoginResponse>> verifyLogin({required VerifyLoginParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.loginAuth, data: params.getBody()),
      fromJson: (json) => VerifyLoginResponse.fromJson(json),
    );
  }
}
