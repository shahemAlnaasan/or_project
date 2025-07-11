import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/credit/data/data_sources/credit_remote_data_source.dart';
import 'package:golder_octopus/features/credit/data/models/incoming_credits_response.dart';
import 'package:golder_octopus/features/credit/data/models/outgoing_credits_response.dart';
import 'package:golder_octopus/features/credit/domain/repositories/credit_repository.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/incoming_credit_usecase.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/outgoing_credit_usecase.dart';
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
}
