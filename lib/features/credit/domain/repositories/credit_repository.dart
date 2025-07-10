import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/outgoing_credit_usecase.dart';

abstract class CreditRepository {
  DataResponse<AccountStatementResponse> outgoingCredits({required OutgoingCreditParams params});
}
