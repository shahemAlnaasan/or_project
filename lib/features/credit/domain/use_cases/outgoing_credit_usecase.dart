import '../../../../common/consts/typedef.dart';
import '../../data/models/outgoing_credits_response.dart';
import '../repositories/credit_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class OutgoingCreditUsecase {
  final CreditRepository creditRepository;

  OutgoingCreditUsecase({required this.creditRepository});

  DataResponse<List<OutgoingCreditResponse>> call({required OutgoingCreditParams params}) {
    return creditRepository.outgoingCredits(params: params);
  }
}

class OutgoingCreditParams with Params {
  final String startDate;
  final String endDate;

  OutgoingCreditParams({required this.startDate, required this.endDate});

  @override
  BodyMap getBody() => {"start_date": startDate, "end_date": endDate};
}
