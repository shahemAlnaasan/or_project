part of 'transfer_bloc.dart';

sealed class TransferEvent extends Equatable {
  const TransferEvent();

  @override
  List<Object> get props => [];
}

class GetIncomingTransfersEvent extends TransferEvent {}

class GetOutgoingTransfersEvent extends TransferEvent {
  final OutgoingTransferParams params;

  const GetOutgoingTransfersEvent({required this.params});
}

class GetReceivedTransfersEvent extends TransferEvent {
  final ReceivedTransfersParams params;

  const GetReceivedTransfersEvent({required this.params});
}

class NewTransferEvent extends TransferEvent {
  final NewTransferParams params;

  const NewTransferEvent({required this.params});
}

class GetTransTargetsEvent extends TransferEvent {}

class GetTargetInfoEvent extends TransferEvent {
  final GetTargetInfoParams params;

  const GetTargetInfoEvent({required this.params});
}

class GetTaxEvent extends TransferEvent {
  final GetTaxParams params;

  const GetTaxEvent({required this.params});
}
