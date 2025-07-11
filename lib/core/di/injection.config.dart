// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../common/utils/local_authentication.dart' as _i3;
import '../../features/account_statement/data/data_sources/account_statement_remote_data_source.dart'
    as _i662;
import '../../features/account_statement/data/repositories/account_statement_repository_imp.dart'
    as _i612;
import '../../features/account_statement/domain/repositories/account_statement_repository.dart'
    as _i854;
import '../../features/account_statement/domain/use_cases/account_statement_usecase.dart'
    as _i14;
import '../../features/account_statement/presentation/bloc/account_statement_bloc.dart'
    as _i128;
import '../../features/auth/data/data_sources/auth_remote_data_source.dart'
    as _i25;
import '../../features/auth/data/repositories/auth_repository_imp.dart'
    as _i872;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/login_usecase.dart' as _i1012;
import '../../features/auth/domain/use_cases/verify_login_usecase.dart'
    as _i821;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/credit/data/data_sources/credit_remote_data_source.dart'
    as _i785;
import '../../features/credit/data/repositories/credit_repository_imp.dart'
    as _i497;
import '../../features/credit/domain/repositories/credit_repository.dart'
    as _i473;
import '../../features/credit/domain/use_cases/incoming_credit_usecase.dart'
    as _i947;
import '../../features/credit/domain/use_cases/outgoing_credit_usecase.dart'
    as _i702;
import '../../features/credit/presentation/bloc/credit_bloc.dart' as _i504;
import '../../features/home/data/data_sources/home_remote_data_source.dart'
    as _i350;
import '../../features/home/data/repositories/home_repository_imp.dart'
    as _i758;
import '../../features/home/domain/repositories/home_repository.dart' as _i0;
import '../../features/home/domain/use_cases/account_info_usecase.dart'
    as _i822;
import '../../features/home/presentation/bloc/home_bloc.dart' as _i202;
import '../../features/main/presentation/bloc/main_bloc.dart' as _i1014;
import '../datasources/hive_helper.dart' as _i330;
import '../network/http_client.dart' as _i1069;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i3.BiometricHelper>(() => _i3.BiometricHelper());
    gh.singleton<_i1014.MainBloc>(() => _i1014.MainBloc());
    gh.lazySingleton<_i330.HiveHelper>(() => _i330.HiveHelper());
    gh.lazySingleton<_i1069.HTTPClient>(() => _i1069.DioClient());
    gh.factory<_i662.AccountStatementRemoteDataSource>(
      () => _i662.AccountStatementRemoteDataSource(
        httpClient: gh<_i1069.HTTPClient>(),
      ),
    );
    gh.factory<_i25.AuthRemoteDataSource>(
      () => _i25.AuthRemoteDataSource(httpClient: gh<_i1069.HTTPClient>()),
    );
    gh.factory<_i785.CreditRemoteDataSource>(
      () => _i785.CreditRemoteDataSource(httpClient: gh<_i1069.HTTPClient>()),
    );
    gh.factory<_i350.HomeRemoteDataSource>(
      () => _i350.HomeRemoteDataSource(httpClient: gh<_i1069.HTTPClient>()),
    );
    gh.factory<_i854.AccountStatementRepository>(
      () => _i612.AccountStatementRepositoryImp(
        accountStatementRemoteDataSource:
            gh<_i662.AccountStatementRemoteDataSource>(),
      ),
    );
    gh.factory<_i473.CreditRepository>(
      () => _i497.CreditRepositoryImp(
        creditRemoteDataSource: gh<_i785.CreditRemoteDataSource>(),
      ),
    );
    gh.factory<_i702.OutgoingCreditUsecase>(
      () => _i702.OutgoingCreditUsecase(
        creditRepository: gh<_i473.CreditRepository>(),
      ),
    );
    gh.factory<_i947.IncomingCreditUsecase>(
      () => _i947.IncomingCreditUsecase(
        creditRepository: gh<_i473.CreditRepository>(),
      ),
    );
    gh.factory<_i787.AuthRepository>(
      () => _i872.AuthRepositoryImp(
        authRemoteDataSource: gh<_i25.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i0.HomeRepository>(
      () => _i758.HomeRepositoryImp(
        remoteDataSource: gh<_i350.HomeRemoteDataSource>(),
      ),
    );
    gh.factory<_i14.AccountStatementUsecase>(
      () => _i14.AccountStatementUsecase(
        accountStatementRepository: gh<_i854.AccountStatementRepository>(),
      ),
    );
    gh.factory<_i128.AccountStatementBloc>(
      () => _i128.AccountStatementBloc(
        accountStatementUsecase: gh<_i14.AccountStatementUsecase>(),
      ),
    );
    gh.factory<_i1012.LoginUsecase>(
      () => _i1012.LoginUsecase(authRepository: gh<_i787.AuthRepository>()),
    );
    gh.factory<_i821.VerifyLoginUsecase>(
      () =>
          _i821.VerifyLoginUsecase(authRepository: gh<_i787.AuthRepository>()),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        loginUsecase: gh<_i1012.LoginUsecase>(),
        verifyLoginUsecase: gh<_i821.VerifyLoginUsecase>(),
      ),
    );
    gh.factory<_i822.AccountInfoUsecase>(
      () => _i822.AccountInfoUsecase(homeRepository: gh<_i0.HomeRepository>()),
    );
    gh.factory<_i504.CreditBloc>(
      () => _i504.CreditBloc(
        outgoingCreditUsecase: gh<_i702.OutgoingCreditUsecase>(),
        incomingCreditUsecase: gh<_i947.IncomingCreditUsecase>(),
      ),
    );
    gh.factory<_i202.HomeBloc>(
      () => _i202.HomeBloc(accountInfoUsecase: gh<_i822.AccountInfoUsecase>()),
    );
    return this;
  }
}
