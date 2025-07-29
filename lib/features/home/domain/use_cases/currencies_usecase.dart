import '../../../../common/consts/typedef.dart';
import '../../../account_statement/data/models/currencies_response.dart';
import '../repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurrenciesUsecase {
  final HomeRepository homeRepository;

  CurrenciesUsecase({required this.homeRepository});

  DataResponse<CurrenciesResponse> call() {
    return homeRepository.currencies();
  }
}
