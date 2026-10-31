import '../../../../core/utils/result.dart';
import '../../data/doctor_models.dart';

abstract class DoctorRepository {
  Future<Result<List<DoctorProfile>>> getDoctors({String? specialty, String? token});
  Future<Result<DoctorProfile>> getDoctorDetails(String doctorId, {String? token});
  Future<Result<DoctorProfile>> updateDoctorProfile(
    String doctorId,
    Map<String, dynamic> data, {
    String? token,
    String? imagePath,
  });
  Future<Result<List<Map<String, dynamic>>>> getSpecialties({String? token});
}
