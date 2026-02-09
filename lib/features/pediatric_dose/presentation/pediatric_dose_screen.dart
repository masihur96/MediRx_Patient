import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class PediatricDoseScreen extends StatelessWidget {
  const PediatricDoseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pediatric Dose'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.baby, color: Colors.pink, size: 40),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Calculate Safe Dosage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.pink)),
                        Text('Based on weight and age', style: TextStyle(color: Colors.pink[300])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildInputLabel('Child\'s Weight (kg)'),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter weight in kg',
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            _buildInputLabel('Medicine Name'),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'e.g., Paracetamol',
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text('CALCULATE DOSE'),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Recent Calculations'),
            const SizedBox(height: 16),
            _buildResultCard('Paracetamol', '2.5 ml', 'Every 6 hours'),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildResultCard(String medicine, String dose, String frequency) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(medicine, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(frequency, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
          Text(dose, style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}
