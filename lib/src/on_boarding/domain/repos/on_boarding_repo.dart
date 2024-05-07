import 'package:education_app/core/utils/typedefs.dart';

abstract class OnBoardingRepo{
  const OnBoardingRepo();
  ResultFuture<void> cacheFirstTime();
  ResultFuture<bool> checkIfUserIsFirstTimer();
}
