import '../../../../common/consts/typedef.dart';
import '../../data/models/account_statement_response.dart';
import '../use_cases/account_statement_usecase.dart';

abstract class AccountStatementRepository {
  DataResponse<AccountStatementResponse> accountStatment({required AccountStatementParams params});
}
