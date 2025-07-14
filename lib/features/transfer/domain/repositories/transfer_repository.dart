import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';
import 'package:golder_octopus/features/transfer/data/models/outgoing_transfer_response.dart';
import 'package:golder_octopus/features/transfer/data/models/received_transfer_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/outgoing_transfers_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/received_transfers_usecase.dart';

abstract class TransferRepository {
  DataResponse<OutgoingTransferResponse> outgoingTransfer({required OutgoingTransferParams params});
  DataResponse<ReceivedTransfersResponse> receivedTransfers({required ReceivedTransfersParams params});
  DataResponse<IncomingTransferResponse> incomingTransfer();
}
