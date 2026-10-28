import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/scheduling_repository.dart';

class GetAppointmentsUseCase implements UseCase<Result<List<Map<String, dynamic>>>, NoParams> {
  final SchedulingRepository _repository;

  GetAppointmentsUseCase(this._repository);

  @override
  Future<Result<List<Map<String, dynamic>>>> call(NoParams params) {
    return _repository.getAppointments();
  }
}
