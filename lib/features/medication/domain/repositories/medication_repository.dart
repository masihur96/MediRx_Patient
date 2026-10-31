import '../../../../core/utils/result.dart';

abstract class MedicationRepository {
  Future<Result<List<Map<String, dynamic>>>> getPrescriptions();
  Future<Result<bool>> addPrescription(Map<String, dynamic> data);
  Future<Result<List<dynamic>>> getMedications({int page = 1});
  Future<Result<List<dynamic>>> getMedicationsList({int page = 1});
  Future<Result<Map<String, dynamic>>> getMedicationsDashboard();
  Future<Result<Map<String, dynamic>>> getMedicationLogs();
  Future<Result<Map<String, dynamic>>> getPrescriptionDetails(dynamic id);
  Future<Result<void>> markMedicationTaken(dynamic logId);
  Future<Result<void>> markMedicationSkipped(dynamic logId);
  Future<Result<void>> markMedicationSnoozed(dynamic logId);
}
