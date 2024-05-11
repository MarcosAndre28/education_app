import 'package:bloc/bloc.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_time_usecase.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer_usecase.dart';
import 'package:equatable/equatable.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit({
    required ICacheFirstTimerUseCase cacheFirstTimer,
    required ICheckIfUserIsFirstTimerUseCase checkIfUserIsFirstTimer,
  })  : _cacheFirstTimer = cacheFirstTimer,
        _checkIfUserIsFirstTimer = checkIfUserIsFirstTimer,
        super(const OnBoardingInitial());

  final ICacheFirstTimerUseCase _cacheFirstTimer;
  final ICheckIfUserIsFirstTimerUseCase _checkIfUserIsFirstTimer;

  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimer());
    final result = await _cacheFirstTimer();

    result.fold(
          (failure) => emit(OnBoardingError(failure.errorMessage)),
          (_) => emit(const UserCached()),
    );
  }

  Future<void> checkIfUserIsFirstTimer() async {
    emit(const CheckingIfUserIsFirstTimer());
    final result = await _checkIfUserIsFirstTimer();
    result.fold(
      (failure) => emit( const OnBoardingStatus(isFirstTime: true)),
      (status) => emit( OnBoardingStatus(isFirstTime: status)),
    );
  }
}
