import 'package:bloc/bloc.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_time_usecase.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer_usecase.dart';
import 'package:equatable/equatable.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit({
    required ICacheFirstTimeUseCase cacheFirstTimeUseCase,
    required ICheckIfUserIsFirstTimerUseCase checkIfUserIsFirstTimeUseCase,
  })  : _cacheFirstTimeUseCase = cacheFirstTimeUseCase,
        _checkIfUserIsFirstTimeUseCase = checkIfUserIsFirstTimeUseCase,
        super(const OnBoardingInitial());

  final ICacheFirstTimeUseCase _cacheFirstTimeUseCase;
  final ICheckIfUserIsFirstTimerUseCase _checkIfUserIsFirstTimeUseCase;

  Future<void> cacheFirstTime() async {
    emit(const CachingFirstTimer());
    final result = await _cacheFirstTimeUseCase();
    result.fold(
      (failure) => emit( OnBoardingError(failure.message)),
      (_) => emit(const UserCached()),
    );
  }

  Future<void> checkIfUserIsFirstTime() async {
    emit(const CheckingIfUserIsFirstTime());
    final result = await _checkIfUserIsFirstTimeUseCase();
    result.fold(
      (failure) => emit( const OnBoardingStatus(isFirstTime: true)),
      (status) => emit( OnBoardingStatus(isFirstTime: status)),
    );
  }
}
