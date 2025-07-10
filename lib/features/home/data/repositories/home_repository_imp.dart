import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:golder_octopus/features/home/data/models/account_info_response.dart';
import 'package:golder_octopus/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImp implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImp({required this.remoteDataSource});

  @override
  DataResponse<AccountInfoResponse> accountInfo() {
    return remoteDataSource.accountInfo();
  }
}
