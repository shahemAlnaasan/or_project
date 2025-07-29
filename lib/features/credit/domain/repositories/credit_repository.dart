import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/credit/data/models/get_companies_response.dart';
import 'package:golder_octopus/features/credit/data/models/get_credit_targets_response.dart';
import 'package:golder_octopus/features/credit/data/models/get_credit_tax_response.dart';
import 'package:golder_octopus/features/credit/data/models/incoming_credits_response.dart';
import 'package:golder_octopus/features/credit/data/models/new_credit_response.dart';
import 'package:golder_octopus/features/credit/data/models/outgoing_credits_response.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/get_credit_targets_usecase.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/get_credit_tax_usecase.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/incoming_credit_usecase.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/new_credit_usecase.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/outgoing_credit_usecase.dart';

abstract class CreditRepository {
  DataResponse<List<OutgoingCreditResponse>> outgoingCredits({required OutgoingCreditParams params});
  DataResponse<List<IncomingCreditsResponse>> incomingCredits({required IncomingCreditParams params});
  DataResponse<GetCompaniesResponse> getCompanies();
  DataResponse<GetCreditTargetsResponse> getCreditTargets({required GetCreditTargetsParams params});
  DataResponse<GetCreditTaxResponse> getCreditTax({required GetCreditTaxParams params});
  DataResponse<NewCreditResponse> newCredit({required NewCreditParams params});
}
