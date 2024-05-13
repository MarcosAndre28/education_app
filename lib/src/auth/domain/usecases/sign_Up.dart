import 'package:education_app/core/usecase/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class SignUp extends UseCaseWithParams<void, SingUpParams> {
  const SignUp(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SingUpParams params) => _repo.signUp(
        email: params.email,
        password: params.password,
       fullName: params.fullName,
      );
}

class SingUpParams extends Equatable {
  const SingUpParams({
    required this.email,
    required this.password,
    required this.fullName,
  });

  const SingUpParams.empty() : this(email: '', password: '', fullName: '');

  final String email;
  final String password;
  final String fullName;

  @override
  List<String> get props => [email, password, fullName];
}
