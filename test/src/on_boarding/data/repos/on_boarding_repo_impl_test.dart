import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/data/datasource/local/on_boarding_local_data_source.dart';
import 'package:education_app/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSrc extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late MockOnBoardingLocalDataSrc mockOnBoardingLocalDataSrc;
  late OnBoardingRepoImpl onBoardingRepoImpl;

  setUp(
    () => {
      mockOnBoardingLocalDataSrc = MockOnBoardingLocalDataSrc(),
      onBoardingRepoImpl = OnBoardingRepoImpl(mockOnBoardingLocalDataSrc),
    },
  );

  test(
    'should be a subclass of [OnBoardingRepo]',
    () => {
      expect(onBoardingRepoImpl, isA<OnBoardingRepoImpl>()),
    },
  );

  group(
    'cacheFirstTime',
    () {
      test(
        'should complete successfully when call to local source is successful',
        () async {
          when(() => mockOnBoardingLocalDataSrc.cacheFirstTimer())
              .thenAnswer((_) async => Future.value());

          final result = await onBoardingRepoImpl.cacheFirstTime();
          expect(result, equals(const Right<dynamic, void>(null)));
          verify(() => mockOnBoardingLocalDataSrc.cacheFirstTimer());
          verifyNoMoreInteractions(mockOnBoardingLocalDataSrc);
        },
      );

      test(
        'should return [CacheFailure] when call to local source is unsuccessful',
        () async {
          when(() => mockOnBoardingLocalDataSrc.cacheFirstTimer()).thenThrow(
            const CacheException(message: 'Insufficient storage'),
          );

          final result = await onBoardingRepoImpl.cacheFirstTime();
          expect(
            result,
            Left<CacheFailure, dynamic>(
              CacheFailure(message: 'Insufficient storage', statusCode: 500),
            ),
          );
          verify(() => mockOnBoardingLocalDataSrc.cacheFirstTimer());
          verifyNoMoreInteractions(mockOnBoardingLocalDataSrc);
        },
      );
    },
  );
}
