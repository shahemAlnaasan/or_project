import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/transfer/data/models/outgoing_transfer_response.dart';
import 'package:golder_octopus/features/transfer/domain/repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class OutgoingTransfersUsecase {
  final TransferRepository transferRepository;

  OutgoingTransfersUsecase({required this.transferRepository});

  DataResponse<OutgoingTransferResponse> call({required OutgoingTransferParams params}) {
    return transferRepository.outgoingTransfer(params: params);
  }
}

class OutgoingTransferParams with Params {
  final String startDate;
  final String endDate;

  OutgoingTransferParams({required this.startDate, required this.endDate});

  @override
  BodyMap getBody() => {"start_date": startDate, "end_date": endDate};
}
