import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../common/consts/app_keys.dart';
import '../../../../common/state_managment/bloc_state.dart';
import '../../../../core/datasources/hive_helper.dart';
import '../../../account_statement/data/models/currencies_response.dart';
import '../../../auth/data/models/login_response_model.dart';
import '../../data/models/get_target_info_response.dart';
import '../../data/models/get_tax_response.dart';
import '../../data/models/get_trans_targets_response.dart';
import '../../data/models/incoming_transfer_response.dart';
import '../../data/models/new_trans_response.dart';
import '../../data/models/outgoing_transfer_response.dart';
import '../../data/models/received_transfer_response.dart';
import '../../data/models/trans_details_response.dart';
import '../../domain/use_cases/get_target_info_usecase.dart';
import '../../domain/use_cases/get_tax_usecase.dart';
import '../../domain/use_cases/get_trans_targets_usecase.dart';
import '../../domain/use_cases/incoming_transfer_usecase.dart';
import '../../domain/use_cases/new_transfer_usecase.dart';
import '../../domain/use_cases/outgoing_transfers_usecase.dart';
import '../../domain/use_cases/received_transfers_usecase.dart';
import '../../domain/use_cases/trans_details_usecase.dart';
import 'package:injectable/injectable.dart';

part 'transfer_event.dart';
part 'transfer_state.dart';

@injectable
class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final IncomingTransferUsecase incomingTransferUsecase;
  final OutgoingTransfersUsecase outgoingTransferUsecase;
  final ReceivedTransfersUsecase receivedTransfersUsecase;
  final NewTransferUsecase newTransferUsecase;
  final GetTransTargetsUsecase getTransTargetsUsecase;
  final GetTargetInfoUsecase getTargetInfoUsecase;
  final GetTaxUsecase getTaxUsecase;
  final TransDetailsUsecase transDetailsUsecase;
  TransferBloc({
    required this.incomingTransferUsecase,
    required this.getTaxUsecase,
    required this.outgoingTransferUsecase,
    required this.receivedTransfersUsecase,
    required this.newTransferUsecase,
    required this.getTransTargetsUsecase,
    required this.getTargetInfoUsecase,
    required this.transDetailsUsecase,
  }) : super(TransferState()) {
    on<GetIncomingTransfersEvent>(_onGetIncomingTransfersEvent);
    on<GetOutgoingTransfersEvent>(_onGetOutgoingTransfersEvent);
    on<GetReceivedTransfersEvent>(_onGetReceivedTransfersEvent);
    on<NewTransferEvent>(_onNewTransferEvent);
    on<GetTransTargetsEvent>(_onGetTransTargetsEvent);
    on<GetTargetInfoEvent>(_onGetTargetInfoEvent);
    on<GetTaxEvent>(_onGetTaxEvent);
    on<GetTransDetailsEvent>(_onGetTransDetailsEvent);
    on<GetIncomingTransDetailsEvent>(_onGetIncomingTransDetailsEvent);
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

  Future<void> _onNewTransferEvent(NewTransferEvent event, Emitter<TransferState> emit) async {
    emit(state.copyWith(newTransferStatus: Status.loading));
    final result = await newTransferUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(newTransferStatus: Status.failure, errorMessage: left.message));
        emit(state.copyWith(newTransferStatus: Status.initial));
      },
      (right) {
        emit(state.copyWith(newTransferStatus: Status.success, newTransResponse: right));
        emit(state.copyWith(newTransferStatus: Status.initial));
      },
    );
  }

  Future<void> _onGetTransTargetsEvent(GetTransTargetsEvent event, Emitter<TransferState> emit) async {
    emit(state.copyWith(getTransTargetsStatus: Status.loading));
    final LoginResponseModel loginResponseModel = await HiveHelper.getFromHive(
      boxName: AppKeys.userBox,
      key: AppKeys.loginResponse,
    );

    final String userId = loginResponseModel.id;
    GetTransTargetsParams params = GetTransTargetsParams(userId: userId);

    final result = await getTransTargetsUsecase(params: params);

    result.fold(
      (left) {
        emit(state.copyWith(getTransTargetsStatus: Status.failure, errorMessage: left.message));
        emit(state.copyWith(getTransTargetsStatus: Status.initial));
      },
      (right) {
        emit(
          state.copyWith(getTransTargetsStatus: Status.success, getTransTargetsResponse: right, getTaxResponse: null),
        );
        emit(state.copyWith(getTransTargetsStatus: Status.initial));
      },
    );
  }

  Future<void> _onGetTargetInfoEvent(GetTargetInfoEvent event, Emitter<TransferState> emit) async {
    emit(state.copyWith(getTargetInfoStatus: Status.loading));
    final result = await getTargetInfoUsecase(params: event.params);

    await result.fold(
      (left) {
        emit(state.copyWith(getTargetInfoStatus: Status.failure, errorMessage: left.message));
        emit(state.copyWith(getTargetInfoStatus: Status.initial));
      },
      (right) async {
        final currenciesResponse = await HiveHelper.getFromHive(
          boxName: AppKeys.userBox,
          key: AppKeys.currenciesResponse,
        );
        emit(
          state.copyWith(
            getTargetInfoStatus: Status.success,
            getTaxStatus: Status.initial,
            getTargetInfoResponse: right,
            currenciesResponse: currenciesResponse,
            getTaxResponse: null,
          ),
        );
        emit(state.copyWith(getTargetInfoStatus: Status.initial));
      },
    );
  }

  Future<void> _onGetTaxEvent(GetTaxEvent event, Emitter<TransferState> emit) async {
    emit(state.copyWith(getTaxStatus: Status.loading));
    final result = await getTaxUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(getTaxStatus: Status.failure, errorMessage: left.message));
        emit(state.copyWith(getTaxStatus: Status.initial));
      },
      (right) {
        emit(state.copyWith(getTaxStatus: Status.success, getTaxResponse: right));
        emit(state.copyWith(getTaxStatus: Status.initial));
      },
    );
  }

  Future<void> _onGetTransDetailsEvent(GetTransDetailsEvent event, Emitter<TransferState> emit) async {
    emit(state.copyWith(transDetailsStatus: Status.loading, transDetailsResponse: null));
    final result = await transDetailsUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(transDetailsStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(
          state.copyWith(
            transDetailsStatus: Status.success,
            transDetailsResponse: right,
            isForDialog: event.isForDialog ? true : false,
          ),
        );
      },
    );
  }

  Future<void> _onGetIncomingTransDetailsEvent(GetIncomingTransDetailsEvent event, Emitter<TransferState> emit) async {
    emit(state.copyWith(incomingTransDetailsStatus: Status.loading));
    final result = await transDetailsUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(incomingTransDetailsStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(incomingTransDetailsStatus: Status.success, incomingTransDetailsResponse: right));
      },
    );
  }
}
