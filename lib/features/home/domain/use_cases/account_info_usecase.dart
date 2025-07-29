import '../../../../common/consts/typedef.dart';
import '../../data/models/account_info_response.dart';
import '../repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AccountInfoUsecase {
  final HomeRepository homeRepository;

  AccountInfoUsecase({required this.homeRepository});

  DataResponse<AccountInfoResponse> call() {
    return homeRepository.accountInfo();
  }
}
