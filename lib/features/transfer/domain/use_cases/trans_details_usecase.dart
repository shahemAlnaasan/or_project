import '../../../../common/consts/typedef.dart';
import '../../data/models/trans_details_response.dart';
import '../repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class TransDetailsUsecase {
  final TransferRepository transferRepository;

  TransDetailsUsecase({required this.transferRepository});

  DataResponse<TransDetailsResponse> call({required TransDetailsParams params}) {
    return transferRepository.transDetails(params: params);
  }
}

class TransDetailsParams with Params {
  final String transNum;

  TransDetailsParams({required this.transNum});

  @override
  BodyMap getBody() => {"transnum": transNum};
}
