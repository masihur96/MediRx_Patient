import '../../../../core/utils/result.dart';

abstract class PediatricDoseRepository {
  Future<Result<List<dynamic>>> getMedicines();
  Future<Result<Map<String, dynamic>>> calculateDose(Map<String, dynamic> params);
  Future<Result<List<dynamic>>> getRecentCalculations({int limit = 10});
}
