import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../common/state_managment/bloc_state.dart';
import '../../data/models/account_statement_response.dart';
import '../../data/models/currencies_response.dart';
import '../../domain/use_cases/account_statement_usecase.dart';
import '../../../home/domain/use_cases/currencies_usecase.dart';
import 'package:injectable/injectable.dart';

part 'account_statement_event.dart';
part 'account_statement_state.dart';

@injectable
class AccountStatementBloc extends Bloc<AccountStatementEvent, AccountStatementState> {
  final AccountStatementUsecase accountStatementUsecase;
  final CurrenciesUsecase currenciesUsecase;
  AccountStatementBloc({required this.accountStatementUsecase, required this.currenciesUsecase})
    : super(AccountStatementState()) {
    on<GetAccountStatementEvent>(_onGetAccountStatementEvent);
    on<GetCurrenciesEvent>(_onGetCurrenciesEvent);
  }

  Future<void> _onGetAccountStatementEvent(GetAccountStatementEvent event, Emitter<AccountStatementState> emit) async {
    emit(state.copyWith(accountStatmentStatus: Status.loading));
    final result = await accountStatementUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(accountStatmentStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(
          state.copyWith(
            accountStatmentStatus: Status.success,
            accountStatement: right,
            fromDate: event.params.startDate,
            toDate: event.params.endDate,
          ),
        );
      },
    );
  }

  Future<void> _onGetCurrenciesEvent(GetCurrenciesEvent event, Emitter<AccountStatementState> emit) async {
    emit(state.copyWith(getCurreciesStatus: Status.loading));
    final result = await currenciesUsecase();
    result.fold(
      (left) {
        emit(state.copyWith(getCurreciesStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getCurreciesStatus: Status.success, currenciesResponse: right));
      },
    );
  }
}
