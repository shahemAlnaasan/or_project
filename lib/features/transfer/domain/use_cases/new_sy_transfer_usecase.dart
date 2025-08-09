import '../../../../common/consts/typedef.dart';
import '../../data/models/new_trans_response.dart';
import '../repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class NewSyTransferUsecase {
  final TransferRepository transferRepository;

  NewSyTransferUsecase({required this.transferRepository});

  DataResponse<NewTransResponse> call({required NewSyTransferParams params}) {
    return transferRepository.newSyTransfer(params: params);
  }
}

class NewSyTransferParams with Params {
  final int target;
  final String rcvname;
  final String rcvphone;
  final String currency;
  final int amount;
  final String api;
  final int amountSy;
  final String isSy;
  final int cut;

  NewSyTransferParams({
    required this.target,
    required this.rcvname,
    required this.rcvphone,
    required this.amount,
    required this.currency,
    required this.amountSy,
    required this.isSy,
    required this.cut,
    required this.api,
  });

  @override
  BodyMap getBody() => {
    "target": target,
    "rcvname": rcvname,
    "rcvphone": rcvphone,
    "amount": amount,
    "currency": currency,
    "amountsy": amountSy,
    "issy": isSy,
    "cut": cut,
    "api": api,
  };
}
