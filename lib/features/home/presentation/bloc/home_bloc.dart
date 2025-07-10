import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/features/home/data/models/account_info_response.dart';
import 'package:golder_octopus/features/home/domain/use_cases/account_info_usecase.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AccountInfoUsecase accountInfoUsecase;
  HomeBloc({required this.accountInfoUsecase}) : super(HomeState()) {
    on<GetAccountInfoEvent>(_onGetAccountInfoEvent);
  }

  Future<void> _onGetAccountInfoEvent(GetAccountInfoEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final result = await accountInfoUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(status: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(status: Status.success, accountInfo: right));
      },
    );
  }
}
