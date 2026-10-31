import '../../../../configs/network/data_provider.dart';
import '../../../../core/constants/apis.dart';

abstract class DashboardRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardOverview();
  Future<Map<String, dynamic>> getVitalsTrends(dynamic patientId);
  Future<Map<String, dynamic>> getDayDetails(String date);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DataProvider _dataProvider;

  DashboardRemoteDataSourceImpl(this._dataProvider);

  @override
  Future<Map<String, dynamic>> getDashboardOverview() async {
    final response = await _dataProvider.get(
      APIPath.patientDashboardOverview,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getVitalsTrends(dynamic patientId) async {
    final response = await _dataProvider.get(
      APIPath.patientVitalsTrends(patientId),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getDayDetails(String date) async {
    final response = await _dataProvider.get(
      APIPath.patientDayDetails(date),
    );
    return response.data as Map<String, dynamic>;
  }
}
