import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golder_octopus/common/consts/app_keys.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/core/datasources/hive_helper.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';
import 'package:golder_octopus/features/account_statement/data/models/currencies_response.dart';
import 'package:golder_octopus/features/account_statement/domain/use_cases/account_statement_usecase.dart';
import 'package:injectable/injectable.dart';

part 'account_statement_event.dart';
part 'account_statement_state.dart';

@injectable
class AccountStatementBloc extends Bloc<AccountStatementEvent, AccountStatementState> {
  final AccountStatementUsecase accountStatementUsecase;
  AccountStatementBloc({required this.accountStatementUsecase}) : super(AccountStatementState()) {
    on<GetAccountStatementEvent>(_onGetAccountStatementEvent);
    on<GetCurrenciesEvent>(_onGetCurrenciesEvent);
  }

  Future<void> _onGetAccountStatementEvent(GetAccountStatementEvent event, Emitter<AccountStatementState> emit) async {
    emit(state.copyWith(status: AcccountStmtStatus.loading));
    final result = await accountStatementUsecase(params: event.params);

    result.fold(
      (left) {
        emit(state.copyWith(status: AcccountStmtStatus.failure, errorMessage: left.message));
      },
      (right) {
        emit(
          state.copyWith(
            status: AcccountStmtStatus.success,
            accountStatement: right,
            fromDate: event.params.startDate,
            toDate: event.params.endDate,
          ),
        );
      },
    );
  }

  Future<void> _onGetCurrenciesEvent(GetCurrenciesEvent event, Emitter<AccountStatementState> emit) async {
    emit(state.copyWith(status: AcccountStmtStatus.loading));
    final currenciesResponse = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.currenciesResponse);
    emit(state.copyWith(getCurreciesStatus: Status.success, currenciesResponse: currenciesResponse));
  }
}
