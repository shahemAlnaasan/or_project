import 'package:dartz/dartz.dart';
import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';
import '../../../../core/config/endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/http_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExchangeRemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  ExchangeRemoteDataSource({required this.httpClient});

  Future<Either<Failure, GetPricesResponse>> getPrices() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getPrices),
      fromJson: (json) => GetPricesResponse.fromJson(json),
      validateApi: false,
    );
  }
}
