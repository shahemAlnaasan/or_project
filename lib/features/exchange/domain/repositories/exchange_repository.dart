import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';
import 'package:golder_octopus/features/exchange/data/models/new_exchange_model.dart';
import 'package:golder_octopus/features/exchange/domain/use_cases/new_exchange_usecase.dart';

import '../../../../common/consts/typedef.dart';

abstract class ExchangeRepository {
  DataResponse<GetPricesResponse> getPrices();
  DataResponse<NewExchangeResponse> newExchange({required NewExchangeParams params});
}
