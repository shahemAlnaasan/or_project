import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/incoming_transfer_usecase.dart';
import 'package:injectable/injectable.dart';

part 'transfer_event.dart';
part 'transfer_state.dart';

@injectable
class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final IncomingTransferUsecase incomingTransferUsecase;
  TransferBloc({required this.incomingTransferUsecase}) : super(TransferState()) {
    on<GetIncomingTransfersEvent>(_onGetIncomingTransfersEvent);
  }

  Future<void> _onGetIncomingTransfersEvent(GetIncomingTransfersEvent event, Emitter<TransferState> emit) async {
    emit(state.copyWith(transferStatus: Status.loading));
    final result = await incomingTransferUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(transferStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(transferStatus: Status.success, incomingTransfers: right));
      },
    );
  }
}
