import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/features/credit/data/models/incoming_credits_response.dart';
import 'package:golder_octopus/features/credit/data/models/outgoing_credits_response.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/incoming_credit_usecase.dart';
import 'package:golder_octopus/features/credit/domain/use_cases/outgoing_credit_usecase.dart';
import 'package:golder_octopus/features/transfer/data/models/trans_details_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/trans_details_usecase.dart';
import 'package:injectable/injectable.dart';

part 'credit_event.dart';
part 'credit_state.dart';

@injectable
class CreditBloc extends Bloc<CreditEvent, CreditState> {
  final OutgoingCreditUsecase outgoingCreditUsecase;
  final IncomingCreditUsecase incomingCreditUsecase;
  final TransDetailsUsecase transDetailsUsecase;
  CreditBloc({
    required this.outgoingCreditUsecase,
    required this.incomingCreditUsecase,
    required this.transDetailsUsecase,
  }) : super(CreditState()) {
    on<GetOutgoingCreditsEvent>(_onGetOutgoingCreditsEvent);
    on<GetIncomingCreditsEvent>(_onGetIncomingCreditsEvent);
    on<GetOutgoingCreditDetailsEvent>(_onGetTransDetailsEvent);
    on<GetIncomingCreditDetailsEvent>(_onGetIncomingCreditDetailsEvent);
  }

  Future<void> _onGetOutgoingCreditsEvent(GetOutgoingCreditsEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(status: CreditStatus.loading));
    final result = await outgoingCreditUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(status: CreditStatus.failure, errorMessage: left.message));
      },
      (right) {
        emit(
          state.copyWith(
            status: CreditStatus.success,
            outgoingCredits: right,
            fromDate: event.params.startDate,
            toDate: event.params.endDate,
          ),
        );
      },
    );
  }

  Future<void> _onGetIncomingCreditsEvent(GetIncomingCreditsEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(status: CreditStatus.loading));
    final result = await incomingCreditUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(status: CreditStatus.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(status: CreditStatus.success, incomingCredits: right));
      },
    );
  }

  Future<void> _onGetTransDetailsEvent(GetOutgoingCreditDetailsEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(outgoingCreditDetailsStatus: Status.loading));
    final result = await transDetailsUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(outgoingCreditDetailsStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(outgoingCreditDetailsStatus: Status.success, outgoingCreditDetailsResponse: right));
      },
    );
  }

  Future<void> _onGetIncomingCreditDetailsEvent(GetIncomingCreditDetailsEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(incomingCreditDetailsStatus: Status.loading));
    final result = await transDetailsUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(incomingCreditDetailsStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(
          state.copyWith(
            incomingCreditDetailsStatus: Status.success,
            incomingCreditDetailsResponse: right,
            isForDialog: event.isForDialog ? true : false,
          ),
        );
      },
    );
  }
}
