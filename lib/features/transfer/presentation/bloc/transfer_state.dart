part of 'transfer_bloc.dart';

class TransferState extends Equatable {
  final Status? incomingTransferStatus;
  final Status? outgoingTransferStatus;
  final Status? receivedTransferStatus;

  final Status? getSyPricesStatus;
  final Status? getSyTargetsStatus;
  final Status? newSyTransferStatus;

  final Status? newTransferStatus;
  final Status? getTransTargetsStatus;
  final Status? getTargetInfoStatus;
  final Status? getTaxStatus;
  final Status? transDetailsStatus;
  final Status? incomingTransDetailsStatus;

  final String? errorMessage;

  final bool isForDialog;

  final IncomingTransferResponse? incomingTransferResponse;
  final OutgoingTransferResponse? outgoingTransferResponse;
  final ReceivedTransfersResponse? receivedTransfersResponse;
  final CurrenciesResponse? currenciesResponse;
  final GetTaxResponse? getTaxResponse;
  final TransDetailsResponse? transDetailsResponse;
  final TransDetailsResponse? incomingTransDetailsResponse;

  final NewTransResponse? newTransResponse;
  final GetTransTargetsResponse? getTransTargetsResponse;
  final GetTargetInfoResponse? getTargetInfoResponse;

  final GetSyPricesResponse? getSyPricesResponse;
  final GetSyTargetsResponse? getSyTargetsResponse;
  final NewTransResponse? newSyTransferResponse;

  final String? fromDate;
  final String? toDate;
  const TransferState({
    this.fromDate,
    this.toDate,
    this.incomingTransferStatus,
    this.outgoingTransferStatus,
    this.receivedTransferStatus,
    this.incomingTransDetailsStatus,
    this.getSyPricesStatus,
    this.getSyTargetsStatus,
    this.newSyTransferStatus,
    this.getSyPricesResponse,
    this.getSyTargetsResponse,
    this.newSyTransferResponse,
    this.transDetailsStatus,
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
    this.transDetailsResponse,
    this.incomingTransDetailsResponse,
    this.isForDialog = true,
  });

  TransferState copyWith({
    Status? incomingTransferStatus,
    Status? outgoingTransferStatus,
    Status? receivedTransferStatus,

    Status? getSyPricesStatus,
    Status? getSyTargetsStatus,
    Status? newSyTransferStatus,

    Status? newTransferStatus,
    Status? getTransTargetsStatus,
    Status? getTargetInfoStatus,
    Status? getTaxStatus,
    Status? transDetailsStatus,
    Status? incomingTransDetailsStatus,

    bool? isForDialog,

    String? errorMessage,

    IncomingTransferResponse? incomingTransferResponse,
    OutgoingTransferResponse? outgoingTransferResponse,
    ReceivedTransfersResponse? receivedTransfersResponse,
    CurrenciesResponse? currenciesResponse,
    GetTaxResponse? getTaxResponse,
    TransDetailsResponse? transDetailsResponse,
    TransDetailsResponse? incomingTransDetailsResponse,

    GetSyPricesResponse? getSyPricesResponse,
    GetSyTargetsResponse? getSyTargetsResponse,
    NewTransResponse? newSyTransferResponse,

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
      transDetailsStatus: transDetailsStatus ?? this.transDetailsStatus,
      incomingTransDetailsStatus: incomingTransDetailsStatus ?? this.incomingTransDetailsStatus,

      getSyPricesStatus: getSyPricesStatus ?? this.getSyPricesStatus,
      getSyTargetsStatus: getSyTargetsStatus ?? this.getSyTargetsStatus,
      newSyTransferStatus: newSyTransferStatus ?? this.newSyTransferStatus,

      isForDialog: isForDialog ?? this.isForDialog,

      newTransferStatus: newTransferStatus ?? this.newTransferStatus,
      getTransTargetsStatus: getTransTargetsStatus ?? this.getTransTargetsStatus,
      getTargetInfoStatus: getTargetInfoStatus ?? this.getTargetInfoStatus,

      errorMessage: errorMessage ?? this.errorMessage,

      receivedTransfersResponse: receivedTransfersResponse ?? this.receivedTransfersResponse,
      incomingTransferResponse: incomingTransferResponse ?? this.incomingTransferResponse,
      outgoingTransferResponse: outgoingTransferResponse ?? this.outgoingTransferResponse,
      currenciesResponse: currenciesResponse ?? this.currenciesResponse,

      getSyPricesResponse: getSyPricesResponse ?? this.getSyPricesResponse,
      getSyTargetsResponse: getSyTargetsResponse ?? this.getSyTargetsResponse,
      newSyTransferResponse: newSyTransferResponse ?? this.newSyTransferResponse,

      newTransResponse: newTransResponse ?? this.newTransResponse,
      getTransTargetsResponse: getTransTargetsResponse ?? this.getTransTargetsResponse,
      getTargetInfoResponse: getTargetInfoResponse ?? this.getTargetInfoResponse,
      getTaxResponse: getTaxResponse ?? this.getTaxResponse,
      transDetailsResponse: transDetailsResponse ?? this.transDetailsResponse,
      incomingTransDetailsResponse: incomingTransDetailsResponse ?? this.incomingTransDetailsResponse,

      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [
    incomingTransferStatus,
    outgoingTransferStatus,
    receivedTransferStatus,
    getSyPricesStatus,
    getSyTargetsStatus,
    newSyTransferStatus,
    transDetailsStatus,
    incomingTransDetailsStatus,
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
    transDetailsResponse,
    incomingTransDetailsResponse,
    getSyPricesResponse,
    getSyTargetsResponse,
    newSyTransferResponse,
    fromDate,
    toDate,
  ];
}
