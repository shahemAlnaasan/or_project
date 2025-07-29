import '../../../../common/consts/typedef.dart';
import '../../data/models/incoming_credits_response.dart';
import '../repositories/credit_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncomingCreditUsecase {
  final CreditRepository creditRepository;

  IncomingCreditUsecase({required this.creditRepository});

  DataResponse<List<IncomingCreditsResponse>> call({required IncomingCreditParams params}) {
    return creditRepository.incomingCredits(params: params);
  }
}

class IncomingCreditParams with Params {
  final String startDate;
  // final String endDate;

  IncomingCreditParams({required this.startDate});

  @override
  BodyMap getBody() => {"start_date": startDate};
}
