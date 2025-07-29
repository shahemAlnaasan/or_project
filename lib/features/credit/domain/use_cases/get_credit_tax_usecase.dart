import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/credit/data/models/get_credit_tax_response.dart';
import 'package:golder_octopus/features/credit/domain/repositories/credit_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCreditTaxUsecase {
  final CreditRepository creditRepository;

  GetCreditTaxUsecase({required this.creditRepository});

  DataResponse<GetCreditTaxResponse> call({required GetCreditTaxParams params}) {
    return creditRepository.getCreditTax(params: params);
  }
}

class GetCreditTaxParams with Params {
  final int amount;
  final String currency;
  final String type;

  GetCreditTaxParams({required this.amount, required this.currency, required this.type});

  @override
  BodyMap getBody() => {"amount": amount, "currency": currency, "type": type};
}
