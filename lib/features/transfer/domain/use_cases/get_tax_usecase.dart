import '../../../../common/consts/typedef.dart';
import '../../data/models/get_tax_response.dart';
import '../repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTaxUsecase {
  final TransferRepository transferRepository;

  GetTaxUsecase({required this.transferRepository});

  DataResponse<GetTaxResponse> call({required GetTaxParams params}) {
    return transferRepository.getTax(params: params);
  }
}

class GetTaxParams with Params {
  final String? target;
  final String amount;
  final String currency;
  final String rcvamount;
  final String rcvcurrency;
  final String api;
  final String rate;
  final String? apiInfo;

  GetTaxParams({
    this.target,
    required this.amount,
    required this.currency,
    required this.rcvamount,
    required this.rcvcurrency,
    required this.api,
    required this.rate,
    this.apiInfo,
  });

  @override
  BodyMap getBody() => {
    "target": target,
    "amount": amount,
    "currency": currency,
    "rcvamount": rcvamount,
    "rcvcurrency": rcvcurrency,
    "api": api,
    "rate": rate,
    "api_info": apiInfo,
  };
}
