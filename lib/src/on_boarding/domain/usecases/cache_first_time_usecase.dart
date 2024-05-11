import 'package:education_app/core/usecase/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';

class ICacheFirstTimerUseCase extends UseCaseWithoutParams<void> {
  const ICacheFirstTimerUseCase(this._repo);

  final OnBoardingRepo _repo;

  @override
  ResultFuture<void> call() async => _repo.cacheFirstTime();
}
