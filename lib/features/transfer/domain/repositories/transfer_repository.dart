import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/transfer/data/models/get_target_info_response.dart';
import 'package:golder_octopus/features/transfer/data/models/get_tax_response.dart';
import 'package:golder_octopus/features/transfer/data/models/get_trans_targets_response.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';
import 'package:golder_octopus/features/transfer/data/models/new_trans_response.dart';
import 'package:golder_octopus/features/transfer/data/models/outgoing_transfer_response.dart';
import 'package:golder_octopus/features/transfer/data/models/received_transfer_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_target_info_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_tax_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_trans_targets_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/new_transfer_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/outgoing_transfers_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/received_transfers_usecase.dart';

abstract class TransferRepository {
  DataResponse<OutgoingTransferResponse> outgoingTransfer({required OutgoingTransferParams params});
  DataResponse<ReceivedTransfersResponse> receivedTransfers({required ReceivedTransfersParams params});
  DataResponse<IncomingTransferResponse> incomingTransfer();
  DataResponse<NewTransResponse> newTransfer({required NewTransferParams params});
  DataResponse<GetTransTargetsResponse> getTransTargets({required GetTransTargetsParams params});
  DataResponse<GetTargetInfoResponse> getTargetInfo({required GetTargetInfoParams params});
  DataResponse<GetTaxResponse> getTax({required GetTaxParams params});
}
