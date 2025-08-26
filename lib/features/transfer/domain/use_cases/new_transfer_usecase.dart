import '../../../../common/consts/typedef.dart';
import '../../data/models/new_trans_response.dart';
import '../repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class NewTransferUsecase {
  final TransferRepository transferRepository;

  NewTransferUsecase({required this.transferRepository});

  DataResponse<NewTransResponse> call({required NewTransferParams params}) {
    return transferRepository.newTransfer(params: params);
  }
}

class NewTransferParams with Params {
  final int target;
  final String rcvname;
  final String rcvphone;
  final int amount;
  final String currency;
  final String notes;
  final String sender;
  final String ipInfo;
  final String deviceInfo;
  final String api;
  final String apiInfo;
  final String apiAddress;

  NewTransferParams({
    required this.target,
    required this.rcvname,
    required this.rcvphone,
    required this.amount,
    required this.currency,
    required this.notes,
    required this.sender,
    required this.ipInfo,
    required this.deviceInfo,
    required this.api,
    required this.apiInfo,
    required this.apiAddress,
  });

  @override
  BodyMap getBody() => {
    "target": target,
    "rcvname": rcvname,
    "rcvphone": rcvphone,
    "amount": amount,
    "currency": currency,
    "notes": notes,
    "sender": sender,
    "ip_info": ipInfo,
    "device_info": deviceInfo,
    "api": api,
    "api_info": apiInfo,
    "api_address": apiAddress,
  };
}
