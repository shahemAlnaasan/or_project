import 'package:dartz/dartz.dart';
import 'package:golder_octopus/core/config/endpoints.dart';
import 'package:golder_octopus/core/network/api_handler.dart';
import 'package:golder_octopus/core/network/exceptions.dart';
import 'package:golder_octopus/core/network/http_client.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';
import 'package:golder_octopus/features/transfer/data/models/outgoing_transfer_response.dart';
import 'package:golder_octopus/features/transfer/data/models/received_transfer_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/outgoing_transfers_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/received_transfers_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class TransferRemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  TransferRemoteDataSource({required this.httpClient});

  Future<Either<Failure, OutgoingTransferResponse>> outgoingTransfer({required OutgoingTransferParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getOutgoingTransfer, data: params.getBody()),
      fromJson: (json) => OutgoingTransferResponse.fromJson(json),
    );
  }

  Future<Either<Failure, IncomingTransferResponse>> incomingTransfer() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getIncomingTransfer),
      fromJson: (json) => IncomingTransferResponse.fromJson(json),
    );
  }

  Future<Either<Failure, ReceivedTransfersResponse>> receivedTransfers({
    required ReceivedTransfersParams params,
  }) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getReceivedTransfer, data: params.getBody()),
      fromJson: (json) => ReceivedTransfersResponse.fromJson(json),
    );
  }
}
