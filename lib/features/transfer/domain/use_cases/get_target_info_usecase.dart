import '../../../../common/consts/typedef.dart';
import '../../data/models/get_target_info_response.dart';
import '../repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTargetInfoUsecase {
  final TransferRepository transferRepository;

  GetTargetInfoUsecase({required this.transferRepository});

  DataResponse<GetTargetInfoResponse> call({required GetTargetInfoParams params}) {
    return transferRepository.getTargetInfo(params: params);
  }
}

class GetTargetInfoParams with Params {
  final String id;
  final String api;

  GetTargetInfoParams({required this.id, required this.api});

  @override
  BodyMap getBody() => {"id": id, "api": api};
}
