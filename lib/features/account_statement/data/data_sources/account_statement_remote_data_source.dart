import 'package:dartz/dartz.dart';
import '../../../../core/config/endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../models/account_statement_response.dart';
import '../../domain/use_cases/account_statement_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class AccountStatementRemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  AccountStatementRemoteDataSource({required this.httpClient});

  Future<Either<Failure, AccountStatementResponse>> accountStatement({required AccountStatementParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.accountStatement, data: params.getBody()),
      fromJson: (json) => AccountStatementResponse.fromJson(json),
    );
  }
}
