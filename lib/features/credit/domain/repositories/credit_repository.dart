import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/credit/data/models/incoming_credits_response.dart';
import 'package:golder_octopus/features/credit/data/models/outgoing_credits_response.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/incoming_credit_usecase.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/outgoing_credit_usecase.dart';

abstract class CreditRepository {
  DataResponse<List<OutgoingCreditResponse>> outgoingCredits({required OutgoingCreditParams params});
  DataResponse<List<IncomingCreditsResponse>> incomingCredits({required IncomingCreditParams params});
}
