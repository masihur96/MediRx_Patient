import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardDataUseCase implements UseCase<Result<Map<String, dynamic>>, NoParams> {
  final DashboardRepository _repository;

  GetDashboardDataUseCase(this._repository);

  @override
  Future<Result<Map<String, dynamic>>> call(NoParams params) {
    return _repository.getDashboardOverview();
  }
}
