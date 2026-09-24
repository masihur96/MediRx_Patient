import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  final List<Map<String, dynamic>> _dummyNotifications = const [
    {
      'title': 'Appointment Confirmed',
      'message': 'Your appointment with Dr. Sarah for tomorrow at 10:00 AM has been confirmed.',
      'time': '2 mins ago',
      'icon': LucideIcons.calendarCheck,
      'color': Colors.green,
      'isRead': false,
    },
    {
      'title': 'Medication Reminder',
      'message': "It's time to take your Atorvastatin (10mg).",
      'time': '1 hour ago',
      'icon': LucideIcons.pill,
      'color': AppColors.primaryTeal,
      'isRead': false,
    },
    {
      'title': 'Lab Results Ready',
      'message': 'Your recent blood test results are now available to view.',
      'time': '5 hours ago',
      'icon': LucideIcons.fileText,
      'color': Colors.blue,
      'isRead': true,
    },
    {
      'title': 'Prescription Renewed',
      'message': 'Dr. Sarah has renewed your prescription for Metformin.',
      'time': 'Yesterday',
      'icon': LucideIcons.checkCircle2,
      'color': Colors.orange,
      'isRead': true,
    },
    {
      'title': 'System Update',
      'message': 'MediRx app has been updated to version 2.0 with new features.',
      'time': '3 days ago',
      'icon': LucideIcons.info,
      'color': Colors.grey,
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _dummyNotifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
        itemBuilder: (context, index) {
          final notif = _dummyNotifications[index];
          final bool isRead = notif['isRead'];

          return Container(
            color: isRead ? Colors.transparent : AppColors.primaryTeal.withOpacity(0.05),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (notif['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notif['icon'] as IconData,
                  color: notif['color'] as Color,
                  size: 24,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      notif['title'] as String,
                      style: TextStyle(
                        fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    notif['time'] as String,
                    style: TextStyle(
                      color: isRead ? Colors.grey[500] : AppColors.primaryTeal,
                      fontSize: 12,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  notif['message'] as String,
                  style: TextStyle(
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ),
              onTap: () {
                // Action on tap
              },
            ),
          );
        },
      ),
    );
  }
}
