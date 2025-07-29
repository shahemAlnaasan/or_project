import '../../../../common/consts/typedef.dart';
import '../../data/models/received_transfer_response.dart';
import '../repositories/transfer_repository.dart';
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
