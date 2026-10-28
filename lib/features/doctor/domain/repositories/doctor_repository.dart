import '../../../../core/utils/result.dart';
import '../../data/doctor_models.dart';

abstract class DoctorRepository {
  Future<Result<List<DoctorProfile>>> getDoctors({String? specialty});
  Future<Result<DoctorProfile>> getDoctorDetails(String doctorId);
}
