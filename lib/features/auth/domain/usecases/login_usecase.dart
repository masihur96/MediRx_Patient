import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String identifier;
  final String password;

  const LoginParams({required this.identifier, required this.password});

  String get email => identifier;
}

class LoginUseCase implements UseCase<Result<UserEntity>, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(LoginParams params) {
    return _repository.login(
      identifier: params.identifier,
      password: params.password,
    );
  }
}
