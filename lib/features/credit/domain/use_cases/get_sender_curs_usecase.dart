import 'package:golder_octopus/features/credit/data/models/get_sender_curs_response.dart';

import '../../../../common/consts/typedef.dart';
import '../repositories/credit_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSenderCursUsecase {
  final CreditRepository creditRepository;

  GetSenderCursUsecase({required this.creditRepository});

  DataResponse<GetSenderCursResponse> call() {
    return creditRepository.getSenderCurs();
  }
}
