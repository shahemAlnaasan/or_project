import '../../../../common/consts/typedef.dart';
import '../../data/models/get_companies_response.dart';
import '../repositories/credit_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCompaniesUsecase {
  final CreditRepository creditRepository;

  GetCompaniesUsecase({required this.creditRepository});

  DataResponse<GetCompaniesResponse> call() {
    return creditRepository.getCompanies();
  }
}
