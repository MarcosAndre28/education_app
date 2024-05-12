import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_time_usecase.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer_usecase.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimeUseCase extends Mock
    implements ICacheFirstTimerUseCase {}

class MockCheckIfUserIsFirstTimerUseCase extends Mock
    implements ICheckIfUserIsFirstTimerUseCase {}

void main() {
  late MockCacheFirstTimeUseCase cacheFirstTimer;
  late MockCheckIfUserIsFirstTimerUseCase checkIfUserIsFirstTimer;
  late OnBoardingCubit cubit;

  setUp(
    () => {
      cacheFirstTimer = MockCacheFirstTimeUseCase(),
      checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimerUseCase(),
      cubit = OnBoardingCubit(
        cacheFirstTimer: cacheFirstTimer,
        checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
      ),
    },
  );

  final tFailure = CacheFailure(
    message: 'Insufficient storage permissions',
    statusCode: 4032,
  );

  test(
    'initial state should be [OnBoardingInitial]',
    () {
      expect(cubit.state, const OnBoardingInitial());
    },
  );

  group(
    'cacheFirstTimer',
    () {
      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [CachingFirstTimer, UserCached] when successful',
        build: () {
          when(() => cacheFirstTimer()).thenAnswer(
                (_) async => const Right(null),
          );
          return cubit;
        },
        act: (cubit) => cubit.cacheFirstTimer(),
        expect: () => const [
          CachingFirstTimer(),
          UserCached(),
        ],
        verify: (_) {
          verify(() => cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );

      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit '
        '[CachingFirstTime, OnBoardingError] when unsuccessful',
        build: () {
          when(() => cacheFirstTimer()).thenAnswer(
                (_) async => Left(tFailure),
          );
          return cubit;
        },
        act: (cubit) => cubit.cacheFirstTimer(),
        expect: () => [
          const CachingFirstTimer(),
          OnBoardingError(tFailure.errorMessage),
        ],
        verify: (_) {
          verify(() => cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );
    },
  );

  group(
    'checkIfUserIsFirstTimer',
    () {
      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [CheckingIfUserIsFirstTimer, OnBoardingStatus] '
        'when successful',
        build: () {
          when(() => checkIfUserIsFirstTimer())
              .thenAnswer((_) async => const Right(false));
          return cubit;
        },
        act: (cubit) => cubit.checkIfUserIsFirstTimer(),
        expect: () => const [
          CheckingIfUserIsFirstTimer(),
          OnBoardingStatus(isFirstTimer: false),
        ],
        verify: (_) {
          verify(() => checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(checkIfUserIsFirstTimer);
        },
      );

      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [CheckingIfUserIsFirstTimer, OnBoardingStatus(true)] '
        'when unsuccessful',
        build: () {
          when(() => checkIfUserIsFirstTimer())
              .thenAnswer((_) async => Left(tFailure),);
          return cubit;
        },
        act: (cubit) => cubit.checkIfUserIsFirstTimer(),
        expect: () => const [
          CheckingIfUserIsFirstTimer(),
          OnBoardingStatus(isFirstTimer: true),
        ],
        verify: (_) {
          verify(() => checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(checkIfUserIsFirstTimer);
        },
      );
    },
  );
}
