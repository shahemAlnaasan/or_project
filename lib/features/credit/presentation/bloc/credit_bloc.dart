import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../common/state_managment/bloc_state.dart';
import '../../../account_statement/data/models/currencies_response.dart';
import '../../data/models/get_companies_response.dart';
import '../../data/models/get_credit_targets_response.dart';
import '../../data/models/get_credit_tax_response.dart';
import '../../data/models/incoming_credits_response.dart';
import '../../data/models/new_credit_response.dart';
import '../../data/models/outgoing_credits_response.dart';
import '../../domain/use_cases/get_companies_usecase.dart';
import '../../domain/use_cases/get_credit_targets_usecase.dart';
import '../../domain/use_cases/get_credit_tax_usecase.dart';
import '../../domain/use_cases/incoming_credit_usecase.dart';
import '../../domain/use_cases/new_credit_usecase.dart';
import '../../domain/use_cases/outgoing_credit_usecase.dart';
import '../../../home/domain/use_cases/currencies_usecase.dart';
import '../../../transfer/data/models/trans_details_response.dart';
import '../../../transfer/domain/use_cases/trans_details_usecase.dart';
import 'package:injectable/injectable.dart';

part 'credit_event.dart';
part 'credit_state.dart';

@injectable
class CreditBloc extends Bloc<CreditEvent, CreditState> {
  final OutgoingCreditUsecase outgoingCreditUsecase;
  final IncomingCreditUsecase incomingCreditUsecase;
  final TransDetailsUsecase transDetailsUsecase;
  final GetCompaniesUsecase getCompaniesUsecase;
  final GetCreditTargetsUsecase getCreditTargetsUsecase;
  final GetCreditTaxUsecase getCreditTaxUsecase;
  final NewCreditUsecase newCreditUsecase;
  final CurrenciesUsecase currenciesUsecase;
  CreditBloc({
    required this.outgoingCreditUsecase,
    required this.incomingCreditUsecase,
    required this.transDetailsUsecase,
    required this.getCompaniesUsecase,
    required this.getCreditTargetsUsecase,
    required this.getCreditTaxUsecase,
    required this.newCreditUsecase,
    required this.currenciesUsecase,
  }) : super(CreditState()) {
    on<GetOutgoingCreditsEvent>(_onGetOutgoingCreditsEvent);
    on<GetIncomingCreditsEvent>(_onGetIncomingCreditsEvent);
    on<GetOutgoingCreditDetailsEvent>(_onGetOutgoingCreditDetailsEvent);
    on<GetIncomingCreditDetailsEvent>(_onGetIncomingCreditDetailsEvent);
    on<GetNewCreditDetailsEvent>(_onGetNewCreditDetailsEvent);
    on<GetCompaniesEvent>(_onGetCompaniesEvent);
    on<GetCreditTargetsEvent>(_onGetCreditTargetsEvent);
    on<GetCreditTaxEvent>(_onGetCreditTaxEvent);
    on<NewCreditEvent>(_onNewCreditEvent);
    on<GetCurrenciesEvent>(_onGetCurrenciesEvent);
  }

  Future<void> _onGetOutgoingCreditsEvent(GetOutgoingCreditsEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(getOutgoingCreditsStatus: Status.loading));
    final result = await outgoingCreditUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(getOutgoingCreditsStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(
          state.copyWith(
            getOutgoingCreditsStatus: Status.success,
            outgoingCredits: right,
            fromDate: event.params.startDate,
            toDate: event.params.endDate,
          ),
        );
      },
    );
  }

  Future<void> _onGetIncomingCreditsEvent(GetIncomingCreditsEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(getIncomingCreditsStatus: Status.loading));
    final result = await incomingCreditUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(getIncomingCreditsStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getIncomingCreditsStatus: Status.success, incomingCredits: right));
      },
    );
  }

  Future<void> _onGetOutgoingCreditDetailsEvent(GetOutgoingCreditDetailsEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(outgoingCreditDetailsStatus: Status.loading));
    final result = await transDetailsUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(outgoingCreditDetailsStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(outgoingCreditDetailsStatus: Status.success, creditDetailsResponse: right));
      },
    );
  }

  Future<void> _onGetNewCreditDetailsEvent(GetNewCreditDetailsEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(newCreditDetailsStatus: Status.loading, newCreditStatus: Status.initial));
    final result = await transDetailsUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(newCreditDetailsStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(newCreditDetailsStatus: Status.success, creditDetailsResponse: right));
      },
    );
  }

  Future<void> _onGetCompaniesEvent(GetCompaniesEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(getCompaniesStatus: Status.loading));
    final result = await getCompaniesUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(getCompaniesStatus: Status.failure, errorMessage: left.message));
        emit(state.copyWith(getCompaniesStatus: Status.initial));
      },
      (right) {
        emit(state.copyWith(getCompaniesStatus: Status.success, getCompaniesResponse: right));
        emit(state.copyWith(getCompaniesStatus: Status.initial));
      },
    );
  }

  Future<void> _onGetCreditTargetsEvent(GetCreditTargetsEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(getCreditTargetsStatus: Status.loading));
    final result = await getCreditTargetsUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(getCreditTargetsStatus: Status.failure, errorMessage: left.message));
        emit(state.copyWith(getCreditTargetsStatus: Status.initial));
      },
      (right) {
        emit(state.copyWith(getCreditTargetsStatus: Status.success, getCreditTargetsResponse: right));
        emit(state.copyWith(getCreditTargetsStatus: Status.initial));
      },
    );
  }

  Future<void> _onGetCreditTaxEvent(GetCreditTaxEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(getCreditTaxStatus: Status.loading));
    final result = await getCreditTaxUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(getCreditTaxStatus: Status.failure, errorMessage: left.message));
        emit(state.copyWith(getCreditTaxStatus: Status.initial));
      },
      (right) {
        emit(state.copyWith(getCreditTaxStatus: Status.success, getCreditTaxResponse: right));
        emit(state.copyWith(getCreditTaxStatus: Status.initial));
      },
    );
  }

  Future<void> _onNewCreditEvent(NewCreditEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(newCreditStatus: Status.loading, newCreditDetailsStatus: Status.initial));
    final result = await newCreditUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(newCreditStatus: Status.failure, errorMessage: left.message));
        emit(state.copyWith(newCreditStatus: Status.initial));
      },
      (right) {
        emit(state.copyWith(newCreditStatus: Status.success, newCreditResponse: right));
        emit(state.copyWith(newCreditStatus: Status.initial));
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
            creditDetailsResponse: right,
            isForDialog: event.isForDialog ? true : false,
          ),
        );
      },
    );
  }

  Future<void> _onGetCurrenciesEvent(GetCurrenciesEvent event, Emitter<CreditState> emit) async {
    emit(state.copyWith(getCurreciesStatus: Status.loading));
    final result = await currenciesUsecase();
    result.fold(
      (left) {
        emit(state.copyWith(getCurreciesStatus: Status.failure, errorMessage: left.message));
        emit(state.copyWith(getCurreciesStatus: Status.initial));
      },
      (right) {
        emit(state.copyWith(getCurreciesStatus: Status.success, currenciesResponse: right));
        emit(state.copyWith(getCurreciesStatus: Status.initial));
      },
    );
  }
}
