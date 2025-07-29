import '../../../../common/consts/typedef.dart';
import '../data_sources/credit_remote_data_source.dart';
import '../models/get_companies_response.dart';
import '../models/get_credit_targets_response.dart';
import '../models/get_credit_tax_response.dart';
import '../models/incoming_credits_response.dart';
import '../models/new_credit_response.dart';
import '../models/outgoing_credits_response.dart';
import '../../domain/repositories/credit_repository.dart';
import '../../domain/use_cases/get_credit_targets_usecase.dart';
import '../../domain/use_cases/get_credit_tax_usecase.dart';
import '../../domain/use_cases/incoming_credit_usecase.dart';
import '../../domain/use_cases/new_credit_usecase.dart';
import '../../domain/use_cases/outgoing_credit_usecase.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CreditRepository)
class CreditRepositoryImp implements CreditRepository {
  final CreditRemoteDataSource creditRemoteDataSource;

  CreditRepositoryImp({required this.creditRemoteDataSource});

  @override
  DataResponse<List<OutgoingCreditResponse>> outgoingCredits({required OutgoingCreditParams params}) {
    return creditRemoteDataSource.outgoingCredits(params: params);
  }

  @override
  DataResponse<List<IncomingCreditsResponse>> incomingCredits({required IncomingCreditParams params}) {
    return creditRemoteDataSource.incomingCredits(params: params);
  }

  @override
  DataResponse<GetCompaniesResponse> getCompanies() {
    return creditRemoteDataSource.getCompanies();
  }

  @override
  DataResponse<GetCreditTargetsResponse> getCreditTargets({required GetCreditTargetsParams params}) {
    return creditRemoteDataSource.getCreditTargets(params: params);
  }

  @override
  DataResponse<GetCreditTaxResponse> getCreditTax({required GetCreditTaxParams params}) {
    return creditRemoteDataSource.getCreditTax(params: params);
  }

  @override
  DataResponse<NewCreditResponse> newCredit({required NewCreditParams params}) {
    return creditRemoteDataSource.newCredit(params: params);
  }
}
