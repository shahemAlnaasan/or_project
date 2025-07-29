import '../../../../common/consts/typedef.dart';
import '../../data/models/get_credit_targets_response.dart';
import '../repositories/credit_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCreditTargetsUsecase {
  final CreditRepository creditRepository;

  GetCreditTargetsUsecase({required this.creditRepository});

  DataResponse<GetCreditTargetsResponse> call({required GetCreditTargetsParams params}) {
    return creditRepository.getCreditTargets(params: params);
  }
}

class GetCreditTargetsParams with Params {
  final String company;
  final String name;

  GetCreditTargetsParams({required this.company, required this.name});

  @override
  BodyMap getBody() => {"company": company, "name": name};
}
