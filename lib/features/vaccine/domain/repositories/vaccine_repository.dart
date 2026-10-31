import '../../../../core/utils/result.dart';

abstract class VaccineRepository {
  Future<Result<List<dynamic>>> getVaccines();
  Future<Result<List<dynamic>>> getVaccinations();
  Future<Result<Map<String, dynamic>>> recordVaccination(Map<String, dynamic> data);
  Future<Result<List<dynamic>>> getVaccinationSchedules();
}
