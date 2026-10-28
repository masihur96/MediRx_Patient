import '../../../../core/utils/result.dart';

abstract class SchedulingRepository {
  Future<Result<List<Map<String, dynamic>>>> getAppointments();
  Future<Result<bool>> bookAppointment(Map<String, dynamic> appointmentData);
  Future<Result<bool>> cancelAppointment(String appointmentId);
}
