import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late UpdateUser updateUser;

  const tUpdateUserAction = UpdateUserAction.email;
  const tUserData = 'Test userData';

  setUp(() {
    repo = MockAuthRepo();
    updateUser = UpdateUser(repo);
    registerFallbackValue(UpdateUserAction.email);
  });

  test(
    'Deve chamar o [AuthRepo.UpdateUser]',
    () async {
      when(
        () => repo.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await updateUser(
        const UpdateUserParams(action: tUpdateUserAction, userData: tUserData),
      );

      expect(result, const Right<dynamic, void>(null));

      verify(
        () => repo.updateUser(
          action: tUpdateUserAction,
          userData: tUserData,
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
