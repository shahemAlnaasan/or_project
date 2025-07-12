part of 'transfer_bloc.dart';

class TransferState extends Equatable {
  final Status? transferStatus;
  final String? errorMessage;
  final IncomingTransferResponse? incomingTransfers;
  final String? fromDate;
  final String? toDate;
  const TransferState({this.fromDate, this.toDate, this.transferStatus, this.errorMessage, this.incomingTransfers});

  TransferState copyWith({
    Status? transferStatus,
    String? errorMessage,
    IncomingTransferResponse? incomingTransfers,
    String? fromDate,
    String? toDate,
  }) {
    return TransferState(
      transferStatus: transferStatus ?? this.transferStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      incomingTransfers: incomingTransfers ?? this.incomingTransfers,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [transferStatus, errorMessage, incomingTransfers, fromDate, toDate];
}
