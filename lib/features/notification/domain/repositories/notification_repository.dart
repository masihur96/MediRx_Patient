import '../../../../core/utils/result.dart';

abstract class NotificationRepository {
  Future<Result<List<dynamic>>> getNotifications();
  Future<Result<void>> markAsRead(dynamic notificationId);
}
