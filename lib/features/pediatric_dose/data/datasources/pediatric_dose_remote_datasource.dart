import '../../../../configs/network/data_provider.dart';
import '../../../../core/constants/apis.dart';

abstract class PediatricDoseRemoteDataSource {
  Future<List<dynamic>> getMedicines();
  Future<Map<String, dynamic>> calculateDose(Map<String, dynamic> params);
  Future<List<dynamic>> getRecentCalculations({int limit = 10});
}

class PediatricDoseRemoteDataSourceImpl implements PediatricDoseRemoteDataSource {
  final DataProvider _dataProvider;

  PediatricDoseRemoteDataSourceImpl(this._dataProvider);

  @override
  Future<List<dynamic>> getMedicines() async {
    final response = await _dataProvider.get(APIPath.pediatricDoseMedicines);
    final data = response.data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    if (data is List) return data;
    return [];
  }

  @override
  Future<Map<String, dynamic>> calculateDose(Map<String, dynamic> params) async {
    final response = await _dataProvider.post(APIPath.pediatricDoseCalculate, data: params);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getRecentCalculations({int limit = 10}) async {
    final response = await _dataProvider.get(
      '${APIPath.pediatricDoseRecent}?limit=$limit',
    );
    final data = response.data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    if (data is List) return data;
    return [];
  }
}
