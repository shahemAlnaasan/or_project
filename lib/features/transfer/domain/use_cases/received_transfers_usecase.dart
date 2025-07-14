import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/transfer/data/models/received_transfer_response.dart';
import 'package:golder_octopus/features/transfer/domain/repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReceivedTransfersUsecase {
  final TransferRepository transferRepository;

  ReceivedTransfersUsecase({required this.transferRepository});

  DataResponse<ReceivedTransfersResponse> call({required ReceivedTransfersParams params}) {
    return transferRepository.receivedTransfers(params: params);
  }
}

class ReceivedTransfersParams with Params {
  final String startDate;
  final String endDate;

  ReceivedTransfersParams({required this.startDate, required this.endDate});

  @override
  BodyMap getBody() => {"start_date": startDate, "end_date": endDate};
}
