import 'package:education_app/core/usecase/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class SignIn extends UseCaseWithParams<LocalUser, SingInParams> {
  const SignIn(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<LocalUser> call(SingInParams params) => _repo.signIn(
        email: params.email,
        password: params.password,
      );
}

class SingInParams extends Equatable {
  const SingInParams({
    required this.email,
    required this.password,
  });

  const SingInParams.empty() : this(email: '', password: '');

  final String email;
  final String password;

  @override
  List<String> get props => [email, password];
}
