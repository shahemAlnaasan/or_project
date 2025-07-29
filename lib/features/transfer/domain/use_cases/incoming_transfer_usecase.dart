import '../../../../common/consts/typedef.dart';
import '../../data/models/incoming_transfer_response.dart';
import '../repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncomingTransferUsecase {
  final TransferRepository transferRepository;

  IncomingTransferUsecase({required this.transferRepository});

  DataResponse<IncomingTransferResponse> call() {
    return transferRepository.incomingTransfer();
  }
}

class IncomingTransferParams with Params {
  final String startDate;
  // final String endDate;

  IncomingTransferParams({required this.startDate});

  @override
  BodyMap getBody() => {"start_date": startDate};
}
