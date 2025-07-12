import 'package:dartz/dartz.dart';
import 'package:golder_octopus/core/config/endpoints.dart';
import 'package:golder_octopus/core/network/api_handler.dart';
import 'package:golder_octopus/core/network/exceptions.dart';
import 'package:golder_octopus/core/network/http_client.dart';
import 'package:golder_octopus/features/credit/data/models/outgoing_credits_response.dart';

import 'package:golder_octopus/features/credit/domain/use_cases/outgoing_credit_usecase.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class TransferRemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  TransferRemoteDataSource({required this.httpClient});

  Future<Either<Failure, List<OutgoingCreditResponse>>> outgoingCredits({required OutgoingCreditParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getOutgoingCredits, data: params.getBody()),
      fromJson: (json) => (json as List).map((e) => OutgoingCreditResponse.fromJson(e)).toList(),
    );
  }

  Future<Either<Failure, IncomingTransferResponse>> incomingTransfer() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getIncomingTransfer),
      fromJson: (json) => IncomingTransferResponse.fromJson(json),
    );
  }
}
