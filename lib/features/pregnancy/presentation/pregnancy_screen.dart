import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PregnancyScreen extends StatelessWidget {
  const PregnancyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregnancy Tracking'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Weekly Highlight Card
          _buildWeeklyHighlight(context),
          const SizedBox(height: 24),

          // Stats Row
          Row(
            children: [
              _buildStatCard(context, 'Current Week', 'Week 24',
                  LucideIcons.calendar, Colors.blue),
              const SizedBox(width: 16),
              _buildStatCard(context, 'Days to Go', '112 Days',
                  LucideIcons.timer, Colors.orange),
            ],
          ),
          const SizedBox(height: 24),

          // Symptoms & Mood
          _buildSectionHeader(context, 'Symptoms & Mood'),
          const SizedBox(height: 12),
          _buildSymptomLogger(context),

          const SizedBox(height: 24),

          // Tips for the Week
          _buildSectionHeader(context, 'Tips for Week 24'),
          const SizedBox(height: 12),
          _buildTipCard(
            context,
            'Stay Hydrated',
            'Drinking plenty of water helps maintain amniotic fluid levels.',
            LucideIcons.droplets,
            Colors.lightBlue,
          ),
          const SizedBox(height: 12),
          _buildTipCard(
            context,
            'Gentle Exercise',
            'Try prenatal yoga or walking to stay active and reduce back pain.',
            LucideIcons.accessibility,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyHighlight(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink[300]!, Colors.pink[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(LucideIcons.baby, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Your baby is the size of a',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const Text(
            'Cantaloupe',
            style: TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '60% through your pregnancy',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildSymptomLogger(BuildContext context) {
    final symptoms = [
      {'name': 'Nausea', 'icon': LucideIcons.frown},
      {'name': 'Back Pain', 'icon': LucideIcons.activity},
      {'name': 'Cravings', 'icon': LucideIcons.pizza},
      {'name': 'Fatigue', 'icon': LucideIcons.batteryLow},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: symptoms.length,
        itemBuilder: (context, index) {
          final s = symptoms[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(s['icon'] as IconData, color: Colors.pink[300]),
                const SizedBox(height: 8),
                Text(s['name'] as String,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w500)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, String title, String desc,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(desc,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
