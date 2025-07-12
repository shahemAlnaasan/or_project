import 'package:golder_octopus/common/consts/typedef.dart';
import 'package:golder_octopus/features/transfer/data/data_sources/transfer_remote_data_source.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';
import 'package:golder_octopus/features/transfer/domain/repositories/transfer_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TransferRepository)
class TransferRepositoryImp implements TransferRepository {
  final TransferRemoteDataSource transferRemoteDataSource;

  TransferRepositoryImp({required this.transferRemoteDataSource});

  @override
  DataResponse<IncomingTransferResponse> incomingTransfer() {
    return transferRemoteDataSource.incomingTransfer();
  }
}
