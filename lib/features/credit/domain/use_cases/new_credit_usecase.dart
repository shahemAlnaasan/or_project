import '../../../../common/consts/typedef.dart';
import '../../data/models/new_credit_response.dart';
import '../repositories/credit_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class NewCreditUsecase {
  final CreditRepository creditRepository;

  NewCreditUsecase({required this.creditRepository});

  DataResponse<NewCreditResponse> call({required NewCreditParams params}) {
    return creditRepository.newCredit(params: params);
  }
}

class NewCreditParams with Params {
  final String company;
  final String amount;
  final String currency;
  final String targetId;
  final String targetName;
  final String ipInfo;
  final String deviceInfo;

  NewCreditParams({
    required this.company,
    required this.amount,
    required this.currency,
    required this.targetId,
    required this.targetName,
    required this.ipInfo,
    required this.deviceInfo,
  });

  @override
  BodyMap getBody() => {
    "company": company,
    "amount": amount,
    "currency": currency,
    "target_id": targetId,
    "target_name": targetName,
    "ip_info": ipInfo,
    "device_info": deviceInfo,
  };
}
