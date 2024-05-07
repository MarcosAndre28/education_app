import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_time_usecase.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer_usecase.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimeUseCase extends Mock
    implements ICacheFirstTimeUseCase {}

class MockCheckIfUserIsFirstTimerUseCase extends Mock
    implements ICheckIfUserIsFirstTimerUseCase {}

void main() {
  late MockCacheFirstTimeUseCase cacheFirstTimeUseCase;
  late MockCheckIfUserIsFirstTimerUseCase checkIfUserIsFirstTimeUseCase;
  late OnBoardingCubit cubit;

  setUp(
    () => {
      cacheFirstTimeUseCase = MockCacheFirstTimeUseCase(),
      checkIfUserIsFirstTimeUseCase = MockCheckIfUserIsFirstTimerUseCase(),
      cubit = OnBoardingCubit(
        cacheFirstTimeUseCase: cacheFirstTimeUseCase,
        checkIfUserIsFirstTimeUseCase: checkIfUserIsFirstTimeUseCase,
      ),
    },
  );

  test(
    'initial state should be [OnBoardingInitial]',
    () {
      expect(cubit.state, const OnBoardingInitial());
    },
  );

  group(
    'cacheFirstTime',
    () {
      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [CachingFirstTime, UserCached]',
        build: () {
          when(() => cacheFirstTimeUseCase())
              .thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.cacheFirstTime(),
        expect: () => const [
          CachingFirstTimer(),
          UserCached(),
        ],
          verify: (_){
            verify(() => cacheFirstTimeUseCase()).called(1);
            verifyNoMoreInteractions(cacheFirstTimeUseCase);
          }
      );
    },
  );
}
