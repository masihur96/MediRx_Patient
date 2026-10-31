import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<Map<String, dynamic>>> getDashboardOverview() async {
    try {
      final response = await _remoteDataSource.getDashboardOverview();
      final data = (response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getVitalsTrends(dynamic patientId) async {
    try {
      final response = await _remoteDataSource.getVitalsTrends(patientId);
      final data = (response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getDayDetails(String date) async {
    try {
      final response = await _remoteDataSource.getDayDetails(date);
      final data = (response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
