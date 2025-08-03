import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/exchange_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPricesUsecase {
  final ExchangeRepository exchangeRepository;

  GetPricesUsecase({required this.exchangeRepository});

  DataResponse<GetPricesResponse> call() {
    return exchangeRepository.getPrices();
  }
}
