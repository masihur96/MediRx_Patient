import 'package:flutter/foundation.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<dynamic> _notifications = [];
  List<dynamic> get notifications => _notifications;

  int get unreadCount =>
      _notifications.where((n) => n['read_at'] == null).length;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getNotifications();
    if (result.isSuccess) {
      _notifications = result.data ?? [];
    } else {
      _errorMessage = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(dynamic notificationId) async {
    final result = await _repository.markAsRead(notificationId);
    if (result.isSuccess) {
      // Optimistically update the local state
      final idx = _notifications.indexWhere((n) =>
          n['id'].toString() == notificationId.toString());
      if (idx != -1) {
        final updated = Map<String, dynamic>.from(
            _notifications[idx] as Map<String, dynamic>);
        updated['read_at'] = DateTime.now().toIso8601String();
        _notifications[idx] = updated;
        notifyListeners();
      }
    }
  }
}
