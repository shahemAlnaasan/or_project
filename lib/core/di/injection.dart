import 'package:get_it/get_it.dart';
import 'package:golder_octopus/core/di/injection.config.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
configureDependencies() => getIt.init();
