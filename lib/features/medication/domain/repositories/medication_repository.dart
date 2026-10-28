import '../../../../core/utils/result.dart';

abstract class MedicationRepository {
  Future<Result<List<Map<String, dynamic>>>> getPrescriptions();
  Future<Result<bool>> addPrescription(Map<String, dynamic> data);
}
