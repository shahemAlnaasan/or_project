part of 'transfer_bloc.dart';

class TransferState extends Equatable {
  final Status? incomingTransferStatus;
  final Status? outgoingTransferStatus;
  final Status? receivedTransferStatus;

  final Status? newTransferStatus;
  final Status? getTransTargetsStatus;
  final Status? getTargetInfoStatus;
  final Status? getTaxStatus;

  final String? errorMessage;

  final IncomingTransferResponse? incomingTransferResponse;
  final OutgoingTransferResponse? outgoingTransferResponse;
  final ReceivedTransfersResponse? receivedTransfersResponse;
  final CurrenciesResponse? currenciesResponse;
  final GetTaxResponse? getTaxResponse;

  final NewTransResponse? newTransResponse;
  final GetTransTargetsResponse? getTransTargetsResponse;
  final GetTargetInfoResponse? getTargetInfoResponse;

  final String? fromDate;
  final String? toDate;
  const TransferState({
    this.fromDate,
    this.toDate,
    this.incomingTransferStatus,
    this.outgoingTransferStatus,
    this.receivedTransferStatus,
    this.getTaxStatus,
    this.newTransferStatus,
    this.getTransTargetsStatus,
    this.getTargetInfoStatus,
    this.receivedTransfersResponse,
    this.errorMessage,
    this.incomingTransferResponse,
    this.outgoingTransferResponse,
    this.newTransResponse,
    this.getTransTargetsResponse,
    this.getTargetInfoResponse,
    this.currenciesResponse,
    this.getTaxResponse,
  });

  TransferState copyWith({
    Status? incomingTransferStatus,
    Status? outgoingTransferStatus,
    Status? receivedTransferStatus,

    Status? newTransferStatus,
    Status? getTransTargetsStatus,
    Status? getTargetInfoStatus,
    Status? getTaxStatus,

    String? errorMessage,

    IncomingTransferResponse? incomingTransferResponse,
    OutgoingTransferResponse? outgoingTransferResponse,
    ReceivedTransfersResponse? receivedTransfersResponse,
    CurrenciesResponse? currenciesResponse,
    GetTaxResponse? getTaxResponse,

    NewTransResponse? newTransResponse,
    GetTransTargetsResponse? getTransTargetsResponse,
    GetTargetInfoResponse? getTargetInfoResponse,

    String? fromDate,
    String? toDate,
  }) {
    return TransferState(
      incomingTransferStatus: incomingTransferStatus ?? this.incomingTransferStatus,
      outgoingTransferStatus: outgoingTransferStatus ?? this.outgoingTransferStatus,
      receivedTransferStatus: receivedTransferStatus ?? this.receivedTransferStatus,
      getTaxStatus: getTaxStatus ?? this.getTaxStatus,

      newTransferStatus: newTransferStatus ?? this.newTransferStatus,
      getTransTargetsStatus: getTransTargetsStatus ?? this.getTransTargetsStatus,
      getTargetInfoStatus: getTargetInfoStatus ?? this.getTargetInfoStatus,

      errorMessage: errorMessage ?? this.errorMessage,

      receivedTransfersResponse: receivedTransfersResponse ?? this.receivedTransfersResponse,
      incomingTransferResponse: incomingTransferResponse ?? this.incomingTransferResponse,
      outgoingTransferResponse: outgoingTransferResponse ?? this.outgoingTransferResponse,
      currenciesResponse: currenciesResponse ?? this.currenciesResponse,

      newTransResponse: newTransResponse ?? this.newTransResponse,
      getTransTargetsResponse: getTransTargetsResponse ?? this.getTransTargetsResponse,
      getTargetInfoResponse: getTargetInfoResponse ?? this.getTargetInfoResponse,
      getTaxResponse: getTaxResponse ?? this.getTaxResponse,

      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [
    incomingTransferStatus,
    outgoingTransferStatus,
    receivedTransferStatus,
    getTaxStatus,
    errorMessage,
    incomingTransferResponse,
    outgoingTransferResponse,
    receivedTransfersResponse,
    getTransTargetsResponse,
    getTargetInfoResponse,
    getTaxResponse,
    newTransResponse,
    currenciesResponse,
    fromDate,
    toDate,
  ];
}
