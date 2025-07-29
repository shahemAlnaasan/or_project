import '../../../../common/consts/typedef.dart';
import '../../../account_statement/data/models/currencies_response.dart';
import '../data_sources/home_remote_data_source.dart';
import '../models/account_info_response.dart';
import '../../domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImp implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImp({required this.remoteDataSource});

  @override
  DataResponse<AccountInfoResponse> accountInfo() {
    return remoteDataSource.accountInfo();
  }

  @override
  DataResponse<CurrenciesResponse> currencies() {
    return remoteDataSource.currencies();
  }
}
