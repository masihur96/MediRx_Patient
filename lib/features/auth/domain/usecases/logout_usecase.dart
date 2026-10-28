import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<Result<bool>, NoParams> {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Result<bool>> call(NoParams params) {
    return _repository.logout();
  }
}
