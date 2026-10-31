import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/hospital_repository.dart';
import '../datasources/hospital_remote_datasource.dart';

class HospitalRepositoryImpl implements HospitalRepository {
  final HospitalRemoteDataSource _remoteDataSource;

  HospitalRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<dynamic>>> getHospitals() async {
    try {
      final data = await _remoteDataSource.getHospitals();
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<List<dynamic>>> getHospitalTypes() async {
    try {
      final data = await _remoteDataSource.getHospitalTypes();
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getHospitalDetail(dynamic id) async {
    try {
      final data = await _remoteDataSource.getHospitalDetail(id);
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
