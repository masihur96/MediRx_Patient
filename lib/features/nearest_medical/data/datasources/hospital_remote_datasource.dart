import '../../../../configs/network/data_provider.dart';
import '../../../../core/constants/apis.dart';

abstract class HospitalRemoteDataSource {
  Future<List<dynamic>> getHospitals();
  Future<List<dynamic>> getHospitalTypes();
  Future<Map<String, dynamic>> getHospitalDetail(dynamic id);
}

class HospitalRemoteDataSourceImpl implements HospitalRemoteDataSource {
  final DataProvider _dataProvider;

  HospitalRemoteDataSourceImpl(this._dataProvider);

  @override
  Future<List<dynamic>> getHospitals() async {
    final response = await _dataProvider.get(APIPath.hospitals);
    final data = response.data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    if (data is List) return data;
    return [];
  }

  @override
  Future<List<dynamic>> getHospitalTypes() async {
    final response = await _dataProvider.get(APIPath.hospitalTypes);
    final data = response.data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    if (data is List) return data;
    return [];
  }

  @override
  Future<Map<String, dynamic>> getHospitalDetail(dynamic id) async {
    final response = await _dataProvider.get(APIPath.hospitalDetail(id));
    return response.data as Map<String, dynamic>;
  }
}
