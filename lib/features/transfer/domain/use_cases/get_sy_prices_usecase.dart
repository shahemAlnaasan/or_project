import 'package:golder_octopus/features/transfer/data/models/get_sy_prices_response.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSyPricesUsecase {
  final TransferRepository transferRepository;

  GetSyPricesUsecase({required this.transferRepository});

  DataResponse<GetSyPricesResponse> call() {
    return transferRepository.getSyPrices();
  }
}
