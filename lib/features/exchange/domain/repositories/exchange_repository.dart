import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';

import '../../../../common/consts/typedef.dart';

abstract class ExchangeRepository {
  DataResponse<GetPricesResponse> getPrices();
}
