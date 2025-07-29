import '../../../../common/consts/typedef.dart';
import '../../../account_statement/data/models/currencies_response.dart';
import '../../data/models/account_info_response.dart';

abstract class HomeRepository {
  DataResponse<AccountInfoResponse> accountInfo();
  DataResponse<CurrenciesResponse> currencies();
}
