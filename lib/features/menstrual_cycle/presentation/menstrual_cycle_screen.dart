import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MenstrualCycleScreen extends StatelessWidget {
  const MenstrualCycleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menstrual Cycle'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cycle Status Header
            _buildCycleHeader(context),
            const SizedBox(height: 24),

            // Mini Calendar View
            _buildMiniCalendar(context),
            const SizedBox(height: 24),

            // Symptoms & Flow
            _buildSectionHeader(context, 'Log Symptoms & Flow'),
            const SizedBox(height: 12),
            _buildLogGrid(context),

            const SizedBox(height: 32),

            // Predictions
            _buildSectionHeader(context, 'Future Predictions'),
            const SizedBox(height: 12),
            _buildPredictionCard(context, 'Next Period', 'March 12, 2026',
                LucideIcons.calendarDays, Colors.red[300]!),
            const SizedBox(height: 12),
            _buildPredictionCard(context, 'Fertility Window', 'Feb 24 - Mar 01',
                LucideIcons.sparkles, Colors.purple[300]!),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(LucideIcons.droplets, color: Colors.red[400], size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Day 14',
            style: TextStyle(
                color: Colors.red[400],
                fontSize: 32,
                fontWeight: FontWeight.bold),
          ),
          const Text(
            'Ovulation phase - High chance of pregnancy',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.red[100],
            color: Colors.red[400],
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCalendar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('February 2026',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton(onPressed: () {}, child: const Text('FULL CALENDAR')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final day = index + 10;
            final isCurrent = day == 14;
            final isPeriod = day >= 1 && day <= 5; // Simplified

            return Container(
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isCurrent
                    ? Colors.red[400]
                    : (isPeriod ? Colors.red[50] : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isCurrent ? Colors.red[400]! : Colors.grey[100]!),
              ),
              child: Column(
                children: [
                  Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                    style: TextStyle(
                        fontSize: 10,
                        color: isCurrent ? Colors.white70 : Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCurrent
                          ? Colors.white
                          : (isPeriod ? Colors.red[400] : Colors.black87),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLogGrid(BuildContext context) {
    final logs = [
      {'name': 'Flow', 'icon': LucideIcons.droplets, 'color': Colors.red},
      {'name': 'Cramps', 'icon': LucideIcons.activity, 'color': Colors.orange},
      {'name': 'Mood', 'icon': LucideIcons.smile, 'color': Colors.blue},
      {
        'name': 'Water',
        'icon': LucideIcons.glassWater,
        'color': Colors.lightBlue
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final Color color = log['color'] as Color;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Row(
            children: [
              Icon(log['icon'] as IconData, color: color, size: 20),
              const SizedBox(width: 12),
              Text(log['name'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              const Icon(LucideIcons.plus, size: 16, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPredictionCard(BuildContext context, String title, String date,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(date,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
