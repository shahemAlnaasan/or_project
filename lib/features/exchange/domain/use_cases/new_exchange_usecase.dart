import 'package:golder_octopus/features/exchange/data/models/new_exchange_model.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/exchange_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class NewExchangeUsecase {
  final ExchangeRepository exchangeRepository;

  NewExchangeUsecase({required this.exchangeRepository});

  DataResponse<NewExchangeResponse> call({required NewExchangeParams params}) {
    return exchangeRepository.newExchange(params: params);
  }
}

class NewExchangeParams with Params {
  final double accfrom;
  final double accto;
  final double cut;
  final String currencyfrom;
  final String currencyto;
  final String ipInfo;
  final String deviceInfo;

  NewExchangeParams({
    required this.accfrom,
    required this.accto,
    required this.cut,
    required this.currencyfrom,
    required this.currencyto,
    required this.ipInfo,
    required this.deviceInfo,
  });

  @override
  BodyMap getBody() => {
    "accfrom": accfrom,
    "accto": accto,
    "cut": cut,
    "currencyfrom": currencyfrom,
    "currencyto": currencyto,
    "ip_info": ipInfo,
    "device_info": deviceInfo,
  };
}
