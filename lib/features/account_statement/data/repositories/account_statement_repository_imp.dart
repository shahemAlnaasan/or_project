import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/account_statement/data/data_sources/account_statement_remote_data_source.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';
import 'package:golder_octopus/features/account_statement/domain/repositories/account_statement_repository.dart';
import 'package:golder_octopus/features/account_statement/domain/use_cases/account_statement_usecase.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AccountStatementRepository)
class AccountStatementRepositoryImp implements AccountStatementRepository {
  final AccountStatementRemoteDataSource accountStatementRemoteDataSource;

  AccountStatementRepositoryImp({required this.accountStatementRemoteDataSource});

  @override
  DataResponse<AccountStatementResponse> accountStatment({required AccountStatementParams params}) {
    return accountStatementRemoteDataSource.accountStatement(params: params);
  }
}
