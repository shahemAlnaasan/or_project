import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';
import 'package:golder_octopus/features/exchange/data/models/new_exchange_model.dart';
import 'package:golder_octopus/features/exchange/domain/use_cases/get_prices_usecase.dart';
import 'package:golder_octopus/features/exchange/domain/use_cases/new_exchange_usecase.dart';
import 'package:injectable/injectable.dart';

part 'exchange_event.dart';
part 'exchange_state.dart';

@injectable
class ExchangeBloc extends Bloc<ExchangeEvent, ExchangeState> {
  final GetPricesUsecase getPricesUsecase;
  final NewExchangeUsecase newExchangeUsecase;
  ExchangeBloc({required this.getPricesUsecase, required this.newExchangeUsecase}) : super(ExchangeState()) {
    on<GetPricesEvent>(_onGetPricesEvent);
    on<NewExchangeEvent>(_onNewExchangeEvent);
  }

  Future<void> _onGetPricesEvent(GetPricesEvent event, Emitter<ExchangeState> emit) async {
    emit(state.copyWith(getPricesStatus: Status.loading));
    final result = await getPricesUsecase();
    result.fold(
      (left) {
        emit(state.copyWith(getPricesStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getPricesStatus: Status.success, getPricesResponse: right));
      },
    );
  }

  Future<void> _onNewExchangeEvent(NewExchangeEvent event, Emitter<ExchangeState> emit) async {
    emit(state.copyWith(newExchangeStatus: Status.loading));
    final result = await newExchangeUsecase(params: event.params);
    result.fold(
      (left) {
        emit(state.copyWith(newExchangeStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(newExchangeStatus: Status.success, newExchangeResponse: right));
      },
    );
  }
}
