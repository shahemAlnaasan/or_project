import 'package:dartz/dartz.dart';
import 'package:golder_octopus/core/config/endpoints.dart';
import 'package:golder_octopus/core/network/api_handler.dart';
import 'package:golder_octopus/core/network/exceptions.dart';
import 'package:golder_octopus/core/network/http_client.dart';
import 'package:golder_octopus/features/home/data/models/account_info_response.dart';
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
}
