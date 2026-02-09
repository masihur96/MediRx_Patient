import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class DoctorRatingScreen extends StatelessWidget {
  const DoctorRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Rating'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildDoctorCard('Dr. Sarah Johnson', 'Cardiologist', 4.8, 124, 'https://i.pravatar.cc/150?u=sarah'),
          const SizedBox(height: 16),
          _buildDoctorCard('Dr. Michael Chen', 'Pediatrician', 4.9, 89, 'https://i.pravatar.cc/150?u=michael'),
          const SizedBox(height: 16),
          _buildDoctorCard('Dr. Emily Davis', 'Dermatologist', 4.7, 156, 'https://i.pravatar.cc/150?u=emily'),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(String name, String specialty, double rating, int reviews, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(specialty, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(LucideIcons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Text('($reviews reviews)', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(LucideIcons.chevronRight, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
