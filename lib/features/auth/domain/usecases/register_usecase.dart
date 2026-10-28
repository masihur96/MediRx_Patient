import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String fullName;
  final String email;
  final String password;
  final String? phone;

  const RegisterParams({
    required this.fullName,
    required this.email,
    required this.password,
    this.phone,
  });
}

class RegisterUseCase implements UseCase<Result<UserEntity>, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(RegisterParams params) {
    return _repository.register(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      phone: params.phone,
    );
  }
}
