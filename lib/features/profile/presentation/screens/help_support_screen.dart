import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(LucideIcons.headphones,
                      size: 60, color: AppColors.primaryTeal),
                  const SizedBox(height: 16),
                  const Text(
                    'How can we help you?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our team is here to assist you with any questions or issues.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildSupportOption(
              context,
              'FAQ',
              'Frequently Asked Questions',
              LucideIcons.helpCircle,
              () {},
            ),
            _buildSupportOption(
              context,
              'Chat with Support',
              'Start a live chat with our team',
              LucideIcons.messageCircle,
              () {},
            ),
            _buildSupportOption(
              context,
              'Email Us',
              'Send us an email for detailed inquiries',
              LucideIcons.mail,
              () {},
            ),
            _buildSupportOption(
              context,
              'Call Us',
              'Speak directly to a support agent',
              LucideIcons.phone,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption(BuildContext context, String title,
      String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.mint,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryTeal, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing:
            const Icon(LucideIcons.chevronRight, size: 20, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
