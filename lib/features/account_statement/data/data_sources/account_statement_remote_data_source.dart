import 'package:dartz/dartz.dart';
import 'package:golder_octopus/core/config/endpoints.dart';
import 'package:golder_octopus/core/network/api_handler.dart';
import 'package:golder_octopus/core/network/exceptions.dart';
import 'package:golder_octopus/core/network/http_client.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';
import 'package:golder_octopus/features/account_statement/domain/use_cases/account_statement_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class AccountStatementRemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  AccountStatementRemoteDataSource({required this.httpClient});

  Future<Either<Failure, AccountStatementResponse>> accountStatement({required AccountStatementParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.accountStatement, data: params.getBody()),
      fromJson: (json) => AccountStatementResponse.fromJson(json),

      validateApi: false,
    );
  }
}
