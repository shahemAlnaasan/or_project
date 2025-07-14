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
