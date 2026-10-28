import '../../../../core/utils/result.dart';

abstract class DashboardRepository {
  Future<Result<Map<String, dynamic>>> getDashboardOverview();
}
