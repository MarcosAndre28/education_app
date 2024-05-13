import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';
void main() {
  late MockAuthRepo repo;
  late SignIn signIn;

  const tEmail = 'Test email';
  const tPassword = 'Test password';

  setUp(() {
    repo = MockAuthRepo();
    signIn = SignIn(repo);
  });

  const tUser = LocalUser.empty();

  test(
    'Deve retornar [LocalUser] do [AuthRepo]',
        () async {
      when(
            () => repo.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(tUser));

      final result =
      await signIn(const SingInParams(email: tEmail, password: tPassword));

      expect(result, const Right<dynamic, LocalUser>(tUser));

      verify(
            () => repo.signIn(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}