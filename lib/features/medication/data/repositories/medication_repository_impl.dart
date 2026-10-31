import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/medication_remote_datasource.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationRemoteDataSource _remoteDataSource;

  MedicationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Map<String, dynamic>>>> getPrescriptions() async {
    try {
      final list = await _remoteDataSource.getPrescriptions();
      return Success(list.cast<Map<String, dynamic>>());
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<bool>> addPrescription(Map<String, dynamic> data) async {
    return Success(true);
  }

  @override
  Future<Result<List<dynamic>>> getMedications({int page = 1}) async {
    try {
      final raw = await _remoteDataSource.getMedications(page: page);
      final list = raw['data'] ?? [];
      return Success(list as List<dynamic>);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<List<dynamic>>> getMedicationsList({int page = 1}) =>
      getMedications(page: page);

  @override
  Future<Result<Map<String, dynamic>>> getMedicationsDashboard() async {
    try {
      final data = await _remoteDataSource.getMedicationsDashboard();
      final inner = (data['data'] is Map<String, dynamic>)
          ? data['data'] as Map<String, dynamic>
          : data;
      return Success(inner);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getMedicationLogs() async {
    try {
      final data = await _remoteDataSource.getMedicationLogs();
      final inner = (data['data'] is Map<String, dynamic>)
          ? data['data'] as Map<String, dynamic>
          : data;
      return Success(inner);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getPrescriptionDetails(dynamic id) async {
    try {
      final data = await _remoteDataSource.getPrescriptionDetails(id);
      final inner = (data['data'] is Map<String, dynamic>)
          ? data['data'] as Map<String, dynamic>
          : data;
      return Success(inner);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<void>> markMedicationTaken(dynamic logId) async {
    try {
      await _remoteDataSource.markMedicationTaken(logId);
      return Success(null);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<void>> markMedicationSkipped(dynamic logId) async {
    try {
      await _remoteDataSource.markMedicationSkipped(logId);
      return Success(null);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<void>> markMedicationSnoozed(dynamic logId) async {
    try {
      await _remoteDataSource.markMedicationSnoozed(logId);
      return Success(null);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
