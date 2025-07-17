import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/transfer/data/data_sources/transfer_remote_data_source.dart';
import 'package:golder_octopus/features/transfer/data/models/get_target_info_response.dart';
import 'package:golder_octopus/features/transfer/data/models/get_tax_response.dart';
import 'package:golder_octopus/features/transfer/data/models/get_trans_targets_response.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';
import 'package:golder_octopus/features/transfer/data/models/new_trans_response.dart';
import 'package:golder_octopus/features/transfer/data/models/outgoing_transfer_response.dart';
import 'package:golder_octopus/features/transfer/data/models/received_transfer_response.dart';
import 'package:golder_octopus/features/transfer/domain/repositories/transfer_repository.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_target_info_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_tax_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_trans_targets_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/new_transfer_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/outgoing_transfers_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/received_transfers_usecase.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TransferRepository)
class TransferRepositoryImp implements TransferRepository {
  final TransferRemoteDataSource transferRemoteDataSource;

  TransferRepositoryImp({required this.transferRemoteDataSource});

  @override
  DataResponse<IncomingTransferResponse> incomingTransfer() {
    return transferRemoteDataSource.incomingTransfer();
  }

  @override
  DataResponse<OutgoingTransferResponse> outgoingTransfer({required OutgoingTransferParams params}) {
    return transferRemoteDataSource.outgoingTransfer(params: params);
  }

  @override
  DataResponse<ReceivedTransfersResponse> receivedTransfers({required ReceivedTransfersParams params}) {
    return transferRemoteDataSource.receivedTransfers(params: params);
  }

  @override
  DataResponse<GetTargetInfoResponse> getTargetInfo({required GetTargetInfoParams params}) {
    return transferRemoteDataSource.getTargetInfo(params: params);
  }

  @override
  DataResponse<GetTransTargetsResponse> getTransTargets({required GetTransTargetsParams params}) {
    return transferRemoteDataSource.getTransTargets(params: params);
  }

  @override
  DataResponse<NewTransResponse> newTransfer({required NewTransferParams params}) {
    return transferRemoteDataSource.newTransfer(params: params);
  }

  @override
  DataResponse<GetTaxResponse> getTax({required GetTaxParams params}) {
    return transferRemoteDataSource.getTax(params: params);
  }
}
