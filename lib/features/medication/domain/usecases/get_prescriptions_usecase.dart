import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/medication_repository.dart';

class GetPrescriptionsUseCase implements UseCase<Result<List<Map<String, dynamic>>>, NoParams> {
  final MedicationRepository _repository;

  GetPrescriptionsUseCase(this._repository);

  @override
  Future<Result<List<Map<String, dynamic>>>> call(NoParams params) {
    return _repository.getPrescriptions();
  }
}
