import '../../../../configs/network/data_provider.dart';
import '../../../../core/constants/apis.dart';

abstract class VaccineRemoteDataSource {
  Future<List<dynamic>> getVaccines();
  Future<List<dynamic>> getVaccinations();
  Future<Map<String, dynamic>> recordVaccination(Map<String, dynamic> data);
  Future<List<dynamic>> getVaccinationSchedules();
}

class VaccineRemoteDataSourceImpl implements VaccineRemoteDataSource {
  final DataProvider _dataProvider;

  VaccineRemoteDataSourceImpl(this._dataProvider);

  @override
  Future<List<dynamic>> getVaccines() async {
    final response = await _dataProvider.get(APIPath.patientVaccines);
    final data = response.data;
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    return [];
  }

  @override
  Future<List<dynamic>> getVaccinations() async {
    final response = await _dataProvider.get(APIPath.patientVaccinations);
    final data = response.data;
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    return [];
  }

  @override
  Future<Map<String, dynamic>> recordVaccination(
      Map<String, dynamic> data) async {
    final response =
        await _dataProvider.post(APIPath.patientVaccinations, data: data);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getVaccinationSchedules() async {
    final response =
        await _dataProvider.get(APIPath.patientVaccinationSchedules);
    final data = response.data;
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    return [];
  }
}
