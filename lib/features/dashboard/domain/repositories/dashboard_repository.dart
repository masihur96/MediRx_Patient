import '../../../../core/utils/result.dart';

abstract class DashboardRepository {
  Future<Result<Map<String, dynamic>>> getDashboardOverview();
  Future<Result<Map<String, dynamic>>> getVitalsTrends(dynamic patientId);
  Future<Result<Map<String, dynamic>>> getDayDetails(String date);
}
