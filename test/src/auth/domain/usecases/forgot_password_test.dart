import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late ForgotPassword forgotPassword;

  const tEmail = 'Test email';

  setUp(() {
    repo = MockAuthRepo();
    forgotPassword = ForgotPassword(repo);
  });

  test(
    'Deve chamar o [AuthRepo.forgotPassword]',
    () async {
      when(
        () => repo.forgotPassword(email: any(named: 'email')),
      ).thenAnswer((_) async => const Right(null));

      final result = await  forgotPassword(tEmail);

      expect(result, const Right<dynamic, void>(null));

      verify(
        () => repo.forgotPassword(
          email: tEmail,
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
