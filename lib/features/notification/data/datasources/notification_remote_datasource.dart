import '../../../../configs/network/data_provider.dart';
import '../../../../core/constants/apis.dart';

abstract class NotificationRemoteDataSource {
  Future<List<dynamic>> getNotifications();
  Future<void> markAsRead(dynamic notificationId);
}

class NotificationRemoteDataSourceImpl
    implements NotificationRemoteDataSource {
  final DataProvider _dataProvider;

  NotificationRemoteDataSourceImpl(this._dataProvider);

  @override
  Future<List<dynamic>> getNotifications() async {
    final response = await _dataProvider.get(APIPath.notifications);
    final data = response.data;
    if (data is Map && data['data'] is List) {
      return data['data'] as List;
    }
    if (data is List) return data;
    return [];
  }

  @override
  Future<void> markAsRead(dynamic notificationId) async {
    await _dataProvider.patch(APIPath.notificationRead(notificationId), data: {});
  }
}
