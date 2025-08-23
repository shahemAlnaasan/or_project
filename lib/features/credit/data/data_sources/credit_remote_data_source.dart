import 'package:dartz/dartz.dart';
import 'package:golder_octopus/features/credit/data/models/get_sender_curs_response.dart';
import '../../../../core/config/endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../models/get_companies_response.dart';
import '../models/get_credit_targets_response.dart';
import '../models/get_credit_tax_response.dart';
import '../models/incoming_credits_response.dart';
import '../models/new_credit_response.dart';
import '../models/outgoing_credits_response.dart';
import '../../domain/use_cases/get_credit_targets_usecase.dart';
import '../../domain/use_cases/get_credit_tax_usecase.dart';
import '../../domain/use_cases/incoming_credit_usecase.dart';
import '../../domain/use_cases/new_credit_usecase.dart';
import '../../domain/use_cases/outgoing_credit_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreditRemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  CreditRemoteDataSource({required this.httpClient});

  Future<Either<Failure, List<OutgoingCreditResponse>>> outgoingCredits({required OutgoingCreditParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getOutgoingCredits, data: params.getBody()),
      fromJson: (json) => (json as List).map((e) => OutgoingCreditResponse.fromJson(e)).toList(),

      validateApi: false,
    );
  }

  Future<Either<Failure, List<IncomingCreditsResponse>>> incomingCredits({required IncomingCreditParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getIncomingCredits, data: params.getBody()),
      fromJson: (json) => (json as List).map((e) => IncomingCreditsResponse.fromJson(e)).toList(),

      validateApi: false,
    );
  }

  Future<Either<Failure, NewCreditResponse>> newCredit({required NewCreditParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.newCredit, data: params.getBody()),
      fromJson: (json) => NewCreditResponse.fromJson(json),
    );
  }

  Future<Either<Failure, GetCreditTaxResponse>> getCreditTax({required GetCreditTaxParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getCreditTax, data: params.getBody()),
      fromJson: (json) => GetCreditTaxResponse.fromJson(json),

      validateApi: false,
    );
  }

  Future<Either<Failure, GetCreditTargetsResponse>> getCreditTargets({required GetCreditTargetsParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getCreditTargets, data: params.getBody()),
      fromJson: (json) => GetCreditTargetsResponse.fromJson(json),

      validateApi: false,
    );
  }

  Future<Either<Failure, GetCompaniesResponse>> getCompanies() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getCompanies),
      fromJson: (json) => GetCompaniesResponse.fromJson(json),

      validateApi: false,
    );
  }

  Future<Either<Failure, GetSenderCursResponse>> getSenderCurs() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getSenderCurs),
      fromJson: (json) => GetSenderCursResponse.fromJson(json),
    );
  }
}
