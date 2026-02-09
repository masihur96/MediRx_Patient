import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class VaccineScreen extends StatelessWidget {
  const VaccineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccine Schedule'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildInfoBox('Next vaccination in 12 days'),
          const SizedBox(height: 24),
          _buildSectionHeader('Upcoming'),
          const SizedBox(height: 16),
          _buildVaccineItem('Influenza (Flu)', 'Oct 20, 2026', 'Annual Shot', LucideIcons.syringe, Colors.amber),
          const SizedBox(height: 16),
          _buildVaccineItem('Hepatitis B', 'Dec 05, 2026', 'Booster Dose', LucideIcons.shieldCheck, Colors.blue),
          const SizedBox(height: 32),
          _buildSectionHeader('Completed'),
          const SizedBox(height: 16),
          _buildVaccineItem('COVID-19', 'Mar 12, 2024', 'Completed', LucideIcons.checkCircle, Colors.green),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryTeal.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.calendar, color: AppColors.primaryTeal),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildVaccineItem(String name, String date, String status, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(status, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          Text(date, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
