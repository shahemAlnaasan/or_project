import 'package:dartz/dartz.dart';
import '../../../../core/config/endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../../../account_statement/data/models/currencies_response.dart';
import '../models/account_info_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeRemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  HomeRemoteDataSource({required this.httpClient});

  Future<Either<Failure, AccountInfoResponse>> accountInfo() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.accountInfo),
      fromJson: (json) => AccountInfoResponse.fromJson(json),
      validateApi: false,
    );
  }

  Future<Either<Failure, CurrenciesResponse>> currencies() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getCurrencies),
      fromJson: (json) => CurrenciesResponse.fromJson(json),
    );
  }
}
