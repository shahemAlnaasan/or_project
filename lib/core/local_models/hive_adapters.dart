import '../../features/account_statement/data/models/currencies_response.dart';
import '../../features/auth/data/models/login_response_model.dart';
import '../../features/auth/domain/use_cases/login_usecase.dart';
import 'package:hive_ce/hive.dart';

@GenerateAdapters([
  AdapterSpec<LoginParams>(),
  AdapterSpec<LoginResponseModel>(),
  AdapterSpec<CurrenciesResponse>(),
  AdapterSpec<Cur>(),
])
part 'hive_adapters.g.dart';
