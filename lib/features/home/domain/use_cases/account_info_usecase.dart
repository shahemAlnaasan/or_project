import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/home/data/models/account_info_response.dart';
import 'package:golder_octopus/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AccountInfoUsecase {
  final HomeRepository homeRepository;

  AccountInfoUsecase({required this.homeRepository});

  DataResponse<AccountInfoResponse> call() {
    return homeRepository.accountInfo();
  }
}
