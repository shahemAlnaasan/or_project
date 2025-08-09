import 'package:golder_octopus/features/transfer/data/models/get_sy_targets_response.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSyTargetsUsecase {
  final TransferRepository transferRepository;

  GetSyTargetsUsecase({required this.transferRepository});

  DataResponse<GetSyTargetsResponse> call({required GetSyTargetsParams params}) {
    return transferRepository.getSyTargets(params: params);
  }
}

class GetSyTargetsParams with Params {
  final String id;

  GetSyTargetsParams({required this.id});

  @override
  BodyMap getBody() => {"id": id};
}
