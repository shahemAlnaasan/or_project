import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';
import 'package:golder_octopus/features/account_statement/domain/use_cases/account_statement_usecase.dart';

abstract class AccountStatementRepository {
  DataResponse<AccountStatementResponse> accountStatment({required AccountStatementParams params});
}
