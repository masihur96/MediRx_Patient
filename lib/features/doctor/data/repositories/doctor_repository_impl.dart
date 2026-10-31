import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../datasources/doctor_remote_datasource.dart';
import '../doctor_models.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource _remoteDataSource;

  DoctorRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<DoctorProfile>> getDoctorDetails(String doctorId, {String? token}) async {
    try {
      final response = await _remoteDataSource.getDoctorProfile(doctorId, token: token);
      if (response['success'] == false) {
        return Error(
          response['message']?.toString() ?? 'Failed to load doctor profile',
          statusCode: response['code'] is int ? response['code'] as int : 400,
        );
      }

      final data = response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : response;

      final profile = DoctorProfile.fromJson(data);
      return Success(profile);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<List<DoctorProfile>>> getDoctors({String? specialty, String? token}) async {
    try {
      final list = await _remoteDataSource.getDoctors(specialty: specialty, token: token);
      final profiles = list
          .whereType<Map<String, dynamic>>()
          .map((json) => DoctorProfile.fromJson(json))
          .toList();
      return Success(profiles);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
