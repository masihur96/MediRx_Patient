import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

class HealthRecordsScreen extends StatelessWidget {
  const HealthRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Records',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHealthRecordCard(
            context,
            'Prescription',
            'Dr. Smith',
            '10 Feb 2026',
            'Viral Fever',
            LucideIcons.fileText,
            AppColors.primaryTeal,
          ),
          _buildHealthRecordCard(
            context,
            'Lab Report',
            'City Lab',
            '05 Feb 2026',
            'Blood Test (CBC)',
            LucideIcons
                .flaskConical, // microsope not available in LucideIcons default set, using flask
            Colors.orange,
          ),
          _buildHealthRecordCard(
            context,
            'Prescription',
            'Dr. Emily',
            '20 Jan 2026',
            'General Checkup',
            LucideIcons.fileText,
            AppColors.primaryTeal,
          ),
          _buildHealthRecordCard(
            context,
            'Vaccination',
            'City Hospital',
            '15 Dec 2025',
            'Flu Shot',
            LucideIcons.syringe,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthRecordCard(BuildContext context, String type,
      String doctor, String date, String title, IconData icon, Color color) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, size: 16, color: color),
                      const SizedBox(width: 8),
                      Text(
                        type,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(LucideIcons.stethoscope,
                    size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  doctor,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: View details
                  },
                  icon: const Icon(LucideIcons.eye,
                      size: 16, color: AppColors.primaryTeal),
                  label: const Text('View',
                      style: TextStyle(color: AppColors.primaryTeal)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
