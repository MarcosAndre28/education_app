import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_time_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late ICacheFirstTimeUseCase useCase;

  setUp(() {
    repo = MockOnBoardingRepo();
    useCase = ICacheFirstTimeUseCase(repo);
  });

  test(
    'should call the [onBoardingRepo.cacheFirstTimer] '
    'and return the right data',
    () async {
      when(() => repo.cacheFirstTime()).thenAnswer(
        (_) async => Left(
          ServerFailure(
            message: 'Unknown Error Occurred',
            statusCode: 500,
          ),
        ),
      );

      final result = await useCase();
      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure(
              message: 'Unknown Error Occurred',
              statusCode: 500,
            ),
          ),
        ),
      );
      verify(() => repo.cacheFirstTime()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
