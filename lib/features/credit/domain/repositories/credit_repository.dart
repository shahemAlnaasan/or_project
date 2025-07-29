import '../../../../common/consts/typedef.dart';
import '../../data/models/get_companies_response.dart';
import '../../data/models/get_credit_targets_response.dart';
import '../../data/models/get_credit_tax_response.dart';
import '../../data/models/incoming_credits_response.dart';
import '../../data/models/new_credit_response.dart';
import '../../data/models/outgoing_credits_response.dart';
import '../use_cases/get_credit_targets_usecase.dart';
import '../use_cases/get_credit_tax_usecase.dart';
import '../use_cases/incoming_credit_usecase.dart';
import '../use_cases/new_credit_usecase.dart';
import '../use_cases/outgoing_credit_usecase.dart';

abstract class CreditRepository {
  DataResponse<List<OutgoingCreditResponse>> outgoingCredits({required OutgoingCreditParams params});
  DataResponse<List<IncomingCreditsResponse>> incomingCredits({required IncomingCreditParams params});
  DataResponse<GetCompaniesResponse> getCompanies();
  DataResponse<GetCreditTargetsResponse> getCreditTargets({required GetCreditTargetsParams params});
  DataResponse<GetCreditTaxResponse> getCreditTax({required GetCreditTaxParams params});
  DataResponse<NewCreditResponse> newCredit({required NewCreditParams params});
}
