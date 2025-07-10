import 'package:golder_octopus/features/auth/data/models/login_response_model.dart';
import 'package:golder_octopus/features/auth/domain/use_cases/login_usecase.dart';
import 'package:hive_ce/hive.dart';

@GenerateAdapters([AdapterSpec<LoginParams>(), AdapterSpec<LoginResponseModel>()])
part 'hive_adapters.g.dart';
