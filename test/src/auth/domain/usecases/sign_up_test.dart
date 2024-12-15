import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:education_app/src/auth/domain/usecases/sign_Up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignUp signUp;

  const tEmail = 'Test email';
  const tFullName = 'Test name';
  const tPassword = 'Test password';

  setUp(() {
    repo = MockAuthRepo();
    signUp = SignUp(repo);
  });

  const tUser = LocalUser.empty();

  test(
    'Deve chamar o [AuthRepo.SignUp]',
    () async {
      when(
        () => repo.signUp(
          email: any(named: 'email'),
          fullName: any(named: 'fullName'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await signUp(
        const SingUpParams(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        ),
      );

      expect(result, const Right<dynamic, void>(null));

      verify(
        () => repo.signUp(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
