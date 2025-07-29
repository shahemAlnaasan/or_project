import '../../../../common/consts/typedef.dart';
import '../data_sources/account_statement_remote_data_source.dart';
import '../models/account_statement_response.dart';
import '../../domain/repositories/account_statement_repository.dart';
import '../../domain/use_cases/account_statement_usecase.dart';
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
