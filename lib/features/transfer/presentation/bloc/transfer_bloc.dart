import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/features/transfer/data/models/incoming_transfer_response.dart';
import 'package:golder_octopus/features/transfer/data/models/outgoing_transfer_response.dart';
import 'package:golder_octopus/features/transfer/data/models/received_transfer_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/incoming_transfer_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/outgoing_transfers_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/received_transfers_usecase.dart';
import 'package:injectable/injectable.dart';

part 'transfer_event.dart';
part 'transfer_state.dart';

@injectable
class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final IncomingTransferUsecase incomingTransferUsecase;
  final OutgoingTransfersUsecase outgoingTransferUsecase;
  final ReceivedTransfersUsecase receivedTransfersUsecase;
  TransferBloc({
    required this.incomingTransferUsecase,
    required this.outgoingTransferUsecase,
    required this.receivedTransfersUsecase,
  }) : super(TransferState()) {
    on<GetIncomingTransfersEvent>(_onGetIncomingTransfersEvent);
    on<GetOutgoingTransfersEvent>(_onGetOutgoingTransfersEvent);
    on<GetReceivedTransfersEvent>(_onGetReceivedTransfersEvent);
  }

  Future<void> _onGetIncomingTransfersEvent(GetIncomingTransfersEvent event, Emitter<TransferState> emit) async {
    emit(state.copyWith(incomingTransferStatus: Status.loading));
    final result = await incomingTransferUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(incomingTransferStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(incomingTransferStatus: Status.success, incomingTransferResponse: right));
      },
    );
  }

  Future<void> _onGetOutgoingTransfersEvent(GetOutgoingTransfersEvent event, Emitter<TransferState> emit) async {
    emit(state.copyWith(outgoingTransferStatus: Status.loading));
    final result = await outgoingTransferUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(outgoingTransferStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(outgoingTransferStatus: Status.success, outgoingTransferResponse: right));
      },
    );
  }

  Future<void> _onGetReceivedTransfersEvent(GetReceivedTransfersEvent event, Emitter<TransferState> emit) async {
    emit(state.copyWith(receivedTransferStatus: Status.loading));
    final result = await receivedTransfersUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(receivedTransferStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(receivedTransferStatus: Status.success, receivedTransfersResponse: right));
      },
    );
  }
}
