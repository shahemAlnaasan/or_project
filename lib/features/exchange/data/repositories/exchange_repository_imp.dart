import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';
import 'package:golder_octopus/features/exchange/data/models/new_exchange_model.dart';
import 'package:golder_octopus/features/exchange/domain/use_cases/new_exchange_usecase.dart';

import '../../../../common/consts/typedef.dart';
import '../data_sources/exchange_remote_data_source.dart';
import '../../domain/repositories/exchange_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExchangeRepository)
class ExchangeRepositoryImp implements ExchangeRepository {
  final ExchangeRemoteDataSource remoteDataSource;

  ExchangeRepositoryImp({required this.remoteDataSource});

  @override
  DataResponse<GetPricesResponse> getPrices() {
    return remoteDataSource.getPrices();
  }

  @override
  DataResponse<NewExchangeResponse> newExchange({required NewExchangeParams params}) {
    return remoteDataSource.newExchange(params: params);
  }
}
