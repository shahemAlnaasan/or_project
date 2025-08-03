import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';

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
}
