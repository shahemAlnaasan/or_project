part of 'transfer_bloc.dart';

class TransferState extends Equatable {
  final Status? incomingTransferStatus;
  final Status? outgoingTransferStatus;
  final Status? receivedTransferStatus;
  final String? errorMessage;
  final IncomingTransferResponse? incomingTransferResponse;
  final OutgoingTransferResponse? outgoingTransferResponse;
  final ReceivedTransfersResponse? receivedTransfersResponse;
  final String? fromDate;
  final String? toDate;
  const TransferState({
    this.fromDate,
    this.toDate,
    this.incomingTransferStatus,
    this.outgoingTransferStatus,
    this.receivedTransferStatus,
    this.receivedTransfersResponse,
    this.errorMessage,
    this.incomingTransferResponse,
    this.outgoingTransferResponse,
  });

  TransferState copyWith({
    Status? incomingTransferStatus,
    Status? outgoingTransferStatus,
    Status? receivedTransferStatus,
    String? errorMessage,
    IncomingTransferResponse? incomingTransferResponse,
    OutgoingTransferResponse? outgoingTransferResponse,
    ReceivedTransfersResponse? receivedTransfersResponse,
    String? fromDate,
    String? toDate,
  }) {
    return TransferState(
      incomingTransferStatus: incomingTransferStatus ?? this.incomingTransferStatus,
      outgoingTransferStatus: outgoingTransferStatus ?? this.outgoingTransferStatus,
      receivedTransferStatus: receivedTransferStatus ?? this.receivedTransferStatus,
      receivedTransfersResponse: receivedTransfersResponse ?? this.receivedTransfersResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      incomingTransferResponse: incomingTransferResponse ?? this.incomingTransferResponse,
      outgoingTransferResponse: outgoingTransferResponse ?? this.outgoingTransferResponse,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [
    incomingTransferStatus,
    outgoingTransferStatus,
    receivedTransferStatus,
    errorMessage,
    incomingTransferResponse,
    outgoingTransferResponse,
    receivedTransfersResponse,
    fromDate,
    toDate,
  ];
}
