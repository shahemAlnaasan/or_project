import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/account_statement/data/models/currencies_response.dart';
import 'package:golder_octopus/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurrenciesUsecase {
  final HomeRepository homeRepository;

  CurrenciesUsecase({required this.homeRepository});

  DataResponse<CurrenciesResponse> call() {
    return homeRepository.currencies();
  }
}
