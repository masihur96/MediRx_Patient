import '../../../../core/utils/result.dart';

abstract class HospitalRepository {
  Future<Result<List<dynamic>>> getHospitals();
  Future<Result<List<dynamic>>> getHospitalTypes();
  Future<Result<Map<String, dynamic>>> getHospitalDetail(dynamic id);
}
