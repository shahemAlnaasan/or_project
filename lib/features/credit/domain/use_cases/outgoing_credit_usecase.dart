import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';
import 'package:golder_octopus/features/credit/domain/repositories/credit_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class OutgoingCreditUsecase {
  final CreditRepository creditRepository;

  OutgoingCreditUsecase({required this.creditRepository});

  DataResponse<AccountStatementResponse> call({required OutgoingCreditParams params}) {
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
