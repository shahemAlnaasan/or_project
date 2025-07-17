import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/transfer/data/models/get_trans_targets_response.dart';
import 'package:golder_octopus/features/transfer/domain/repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTransTargetsUsecase {
  final TransferRepository transferRepository;

  GetTransTargetsUsecase({required this.transferRepository});

  DataResponse<GetTransTargetsResponse> call({required GetTransTargetsParams params}) {
    return transferRepository.getTransTargets(params: params);
  }
}

class GetTransTargetsParams with Params {
  final String userId;

  GetTransTargetsParams({required this.userId});

  @override
  BodyMap getBody() => {"id": userId};
}
