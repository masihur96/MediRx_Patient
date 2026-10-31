import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/pediatric_dose_repository.dart';
import '../datasources/pediatric_dose_remote_datasource.dart';

class PediatricDoseRepositoryImpl implements PediatricDoseRepository {
  final PediatricDoseRemoteDataSource _remoteDataSource;

  PediatricDoseRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<dynamic>>> getMedicines() async {
    try {
      final data = await _remoteDataSource.getMedicines();
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> calculateDose(
      Map<String, dynamic> params) async {
    try {
      final data = await _remoteDataSource.calculateDose(params);
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
  Future<Result<List<dynamic>>> getRecentCalculations({int limit = 10}) async {
    try {
      final data =
          await _remoteDataSource.getRecentCalculations(limit: limit);
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
