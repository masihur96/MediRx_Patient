import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/vaccine_repository.dart';
import '../datasources/vaccine_remote_datasource.dart';

class VaccineRepositoryImpl implements VaccineRepository {
  final VaccineRemoteDataSource _remoteDataSource;

  VaccineRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<dynamic>>> getVaccines() async {
    try {
      final data = await _remoteDataSource.getVaccines();
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<List<dynamic>>> getVaccinations() async {
    try {
      final data = await _remoteDataSource.getVaccinations();
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> recordVaccination(
      Map<String, dynamic> data) async {
    try {
      final result = await _remoteDataSource.recordVaccination(data);
      return Success(result);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<List<dynamic>>> getVaccinationSchedules() async {
    try {
      final data = await _remoteDataSource.getVaccinationSchedules();
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
