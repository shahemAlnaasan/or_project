import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/home/data/models/account_info_response.dart';

abstract class HomeRepository {
  DataResponse<AccountInfoResponse> accountInfo();
}
