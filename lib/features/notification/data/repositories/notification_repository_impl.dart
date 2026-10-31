import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<dynamic>>> getNotifications() async {
    try {
      final data = await _remoteDataSource.getNotifications();
      return Success(data);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<void>> markAsRead(dynamic notificationId) async {
    try {
      await _remoteDataSource.markAsRead(notificationId);
      return Success(null);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
