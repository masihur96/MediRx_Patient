import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../presentation/viewmodels/notification_viewmodel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationViewModel>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: () =>
                context.read<NotificationViewModel>().fetchNotifications(),
          ),
        ],
      ),
      body: Consumer<NotificationViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage != null && vm.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.alertCircle,
                      color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(vm.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.fetchNotifications(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (vm.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.bellOff,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No notifications yet',
                      style: TextStyle(
                          color: Colors.grey[500], fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("You're all caught up!",
                      style: TextStyle(
                          color: Colors.grey[400], fontSize: 13)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => vm.fetchNotifications(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notification = vm.notifications[index]
                    as Map<String, dynamic>;
                return _NotificationCard(
                  notification: notification,
                  onTap: () {
                    final id =
                        notification['id']?.toString() ?? '';
                    if (id.isNotEmpty &&
                        notification['read_at'] == null) {
                      vm.markAsRead(id);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification['read_at'] != null;
    final title = _extractTitle();
    final message = _extractMessage();
    final createdAt = notification['created_at']?.toString() ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead
              ? Theme.of(context).colorScheme.surface
              : AppColors.primaryTeal.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead
                ? Colors.grey.withValues(alpha: 0.12)
                : AppColors.primaryTeal.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isRead ? Colors.grey : AppColors.primaryTeal)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isRead ? LucideIcons.bell : LucideIcons.bellRing,
                color: isRead ? Colors.grey : AppColors.primaryTeal,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryTeal,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                  if (createdAt.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(createdAt),
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _extractTitle() {
    // Notifications often come as {type, data: {title, message}}
    if (notification['data'] is Map) {
      final data = notification['data'] as Map;
      return data['title']?.toString() ??
          data['subject']?.toString() ??
          (notification['type'] != null
              ? notification['type'].toString().replaceAll('_', ' ')
              : 'Notification');
    }
    return notification['title']?.toString() ??
        notification['subject']?.toString() ??
        'Notification';
  }

  String _extractMessage() {
    if (notification['data'] is Map) {
      final data = notification['data'] as Map;
      return data['message']?.toString() ??
          data['body']?.toString() ??
          '';
    }
    return notification['message']?.toString() ??
        notification['body']?.toString() ??
        '';
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays == 1) return 'Yesterday';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
