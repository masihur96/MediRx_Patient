import '../../../../configs/network/data_provider.dart';
import '../../../../core/constants/apis.dart';

abstract class MedicationRemoteDataSource {
  Future<Map<String, dynamic>> getMedications({int page = 1});
  Future<Map<String, dynamic>> getMedicationsDashboard();
  Future<Map<String, dynamic>> getMedicationLogs();
  Future<List<dynamic>> getPrescriptions({int page = 1});
  Future<Map<String, dynamic>> getPrescriptionDetails(dynamic id);
  Future<void> markMedicationTaken(dynamic logId);
  Future<void> markMedicationSkipped(dynamic logId);
  Future<void> markMedicationSnoozed(dynamic logId);
}

class MedicationRemoteDataSourceImpl implements MedicationRemoteDataSource {
  final DataProvider _dataProvider;

  MedicationRemoteDataSourceImpl(this._dataProvider);

  @override
  Future<Map<String, dynamic>> getMedications({int page = 1}) async {
    final response = await _dataProvider.get(
      '${APIPath.patientMedications}?page=$page',
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getMedicationsDashboard() async {
    final response = await _dataProvider.get(
      APIPath.patientMedicationsDashboard,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getMedicationLogs() async {
    final response = await _dataProvider.get(
      APIPath.patientMedicationLogs,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getPrescriptions({int page = 1}) async {
    final response = await _dataProvider.get(
      '${APIPath.patientPrescriptions}?page=$page',
    );
    final data = response.data;
    if (data is Map && data.containsKey('data')) {
      return data['data'] as List<dynamic>;
    }
    if (data is List) return data;
    return [];
  }

  @override
  Future<Map<String, dynamic>> getPrescriptionDetails(dynamic id) async {
    final response = await _dataProvider.get(
      APIPath.patientPrescriptionDetails(id),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> markMedicationTaken(dynamic logId) async {
    await _dataProvider.post(APIPath.patientMedicationLogTaken(logId), data: {});
  }

  @override
  Future<void> markMedicationSkipped(dynamic logId) async {
    await _dataProvider.post(APIPath.patientMedicationLogSkip(logId), data: {});
  }

  @override
  Future<void> markMedicationSnoozed(dynamic logId) async {
    await _dataProvider.post(APIPath.patientMedicationLogSnooze(logId), data: {});
  }
}
