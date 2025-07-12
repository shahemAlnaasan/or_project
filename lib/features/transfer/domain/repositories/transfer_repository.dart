import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';

abstract class TransferRepository {
  // DataResponse<List<OutgoingCreditResponse>> outgoingCredits({required OutgoingCreditParams params});
  DataResponse<IncomingTransferResponse> incomingTransfer();
}
