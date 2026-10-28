import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String password;
  final String passwordConfirmation;
  final String registrationType;
  final String? bmdcNumber;

  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.password,
    required this.passwordConfirmation,
    required this.registrationType,
    this.bmdcNumber,
  });
}

class RegisterUseCase implements UseCase<Result<UserEntity>, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(RegisterParams params) {
    return _repository.register(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      mobile: params.mobile,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
      registrationType: params.registrationType,
      bmdcNumber: params.bmdcNumber,
    );
  }
}
