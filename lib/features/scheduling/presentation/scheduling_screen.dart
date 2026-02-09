import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class SchedulingScreen extends StatelessWidget {
  final bool isTab;
  const SchedulingScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        _buildCalendarStrip(),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _buildScheduleItem('Morning Medicine', '08:00 AM', 'Atorvastatin', LucideIcons.sun, Colors.orange),
              const SizedBox(height: 16),
              _buildScheduleItem('Doctor Appointment', '11:30 AM', 'Dr. Sarah Johnson', LucideIcons.calendar, Colors.blue),
              const SizedBox(height: 16),
              _buildScheduleItem('Blood Pressure Check', '06:00 PM', 'Daily tracking', LucideIcons.activity, Colors.red),
            ],
          ),
        ),
      ],
    );

    if (isTab) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduling & Tracking'),
      ),
      body: body,
    );
  }

  Widget _buildCalendarStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final isToday = index == 3;
          return Column(
            children: [
              Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isToday ? AppColors.primaryTeal : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  (index + 5).toString(),
                  style: TextStyle(
                    color: isToday ? Colors.white : Colors.black,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildScheduleItem(String title, String time, String subtitle, IconData icon, Color color) {
    return Row(
      children: [
        Column(
          children: [
            Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Container(height: 40, width: 2, color: Colors.grey[200]),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
