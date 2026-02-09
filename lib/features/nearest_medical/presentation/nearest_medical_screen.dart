import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

class NearestMedicalScreen extends StatelessWidget {
  const NearestMedicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nearest Medical'),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for hospitals, clinics...',
                prefixIcon: const Icon(LucideIcons.search, size: 20),
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildFacilityCard('City General Hospital', '0.8 km away',
                    'Open 24/7', LucideIcons.building2, Colors.blue),
                const SizedBox(height: 16),
                _buildFacilityCard('MediCare Clinic', '1.2 km away',
                    'Closes at 10 PM', LucideIcons.home, Colors.green),
                const SizedBox(height: 16),
                _buildFacilityCard('Emergency Care Center', '2.5 km away',
                    'Open 24/7', LucideIcons.thermometer, Colors.cyan),
              ],
            ),
          ),
        ]));
  }

  Widget _buildFacilityCard(
      String name, String distance, String status, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(LucideIcons.navigation,
                        size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(distance,
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12)),
                    const SizedBox(width: 12),
                    Text(status,
                        style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(LucideIcons.phone, color: AppColors.primaryTeal),
          ),
        ],
      ),
    );
  }
}
