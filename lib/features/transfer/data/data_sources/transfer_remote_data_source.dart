import 'package:dartz/dartz.dart';
import 'package:golder_octopus/features/transfer/data/models/get_sy_prices_response.dart';
import 'package:golder_octopus/features/transfer/data/models/get_sy_targets_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_sy_targets_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/new_sy_transfer_usecase.dart';
import '../../../../core/config/endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../models/get_target_info_response.dart';
import '../models/get_tax_response.dart';
import '../models/get_trans_targets_response.dart';
import '../models/incoming_transfer_response.dart';
import '../models/new_trans_response.dart';
import '../models/outgoing_transfer_response.dart';
import '../models/received_transfer_response.dart';
import '../models/trans_details_response.dart';
import '../../domain/use_cases/get_target_info_usecase.dart';
import '../../domain/use_cases/get_tax_usecase.dart';
import '../../domain/use_cases/get_trans_targets_usecase.dart';
import '../../domain/use_cases/new_transfer_usecase.dart';
import '../../domain/use_cases/outgoing_transfers_usecase.dart';
import '../../domain/use_cases/received_transfers_usecase.dart';
import '../../domain/use_cases/trans_details_usecase.dart';
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

  Future<Either<Failure, NewTransResponse>> newTransfer({required NewTransferParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.newTransfer, data: params.getBody()),
      fromJson: (json) => NewTransResponse.fromJson(json),
    );
  }

  Future<Either<Failure, NewTransResponse>> newSyTransfer({required NewSyTransferParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.newTransfer, data: params.getBody()),
      fromJson: (json) => NewTransResponse.fromJson(json),
    );
  }

  Future<Either<Failure, GetTransTargetsResponse>> getTransTargets({required GetTransTargetsParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getTransTargets, data: params.getBody()),
      fromJson: (json) => GetTransTargetsResponse.fromJson(json),
    );
  }

  Future<Either<Failure, GetTargetInfoResponse>> getTargetInfo({required GetTargetInfoParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getTargetInfo, data: params.getBody()),
      fromJson: (json) => GetTargetInfoResponse.fromJson(json),
    );
  }

  Future<Either<Failure, GetTaxResponse>> getTax({required GetTaxParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getTax, data: params.getBody()),
      fromJson: (json) => GetTaxResponse.fromJson(json),
    );
  }

  Future<Either<Failure, TransDetailsResponse>> transDetails({required TransDetailsParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getTransDetails, data: params.getBody()),
      fromJson: (json) => TransDetailsResponse.fromJson(json),
    );
  }

  Future<Either<Failure, GetSyPricesResponse>> getSyPrices() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getSyPrices),
      fromJson: (json) => GetSyPricesResponse.fromJson(json),
      validateApi: false,
    );
  }

  Future<Either<Failure, GetSyTargetsResponse>> getSyTargets({required GetSyTargetsParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getSyTargets, data: params.getBody()),
      fromJson: (json) => GetSyTargetsResponse.fromJson(json),
    );
  }
}
