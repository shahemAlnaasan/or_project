import '../../../../common/consts/typedef.dart';
import '../../data/models/account_statement_response.dart';
import '../repositories/account_statement_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AccountStatementUsecase {
  final AccountStatementRepository accountStatementRepository;

  AccountStatementUsecase({required this.accountStatementRepository});

  DataResponse<AccountStatementResponse> call({required AccountStatementParams params}) {
    return accountStatementRepository.accountStatment(params: params);
  }
}

class AccountStatementParams with Params {
  final String startDate;
  final String endDate;
  final String currency;

  AccountStatementParams({required this.startDate, required this.currency, required this.endDate});

  @override
  BodyMap getBody() => {"start_date": startDate, "end_date": endDate, "currency": currency};
}
