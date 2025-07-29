import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/credit/data/models/get_companies_response.dart';
import 'package:golder_octopus/features/credit/domain/repositories/credit_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCompaniesUsecase {
  final CreditRepository creditRepository;

  GetCompaniesUsecase({required this.creditRepository});

  DataResponse<GetCompaniesResponse> call() {
    return creditRepository.getCompanies();
  }
}
