import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _twoFactorEnabled = true;
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionHeader('Security'),
            const SizedBox(height: 16),
            _buildSettingTile(
              context,
              'Change Password',
              'Update your password regularly',
              LucideIcons.lock,
              onTap: () {},
            ),
            _buildSwitchTile(
              'Two-Factor Authentication',
              'Secure your account with 2FA',
              _twoFactorEnabled,
              (value) {
                setState(() {
                  _twoFactorEnabled = value;
                });
              },
              LucideIcons.shieldCheck,
            ),
            _buildSwitchTile(
              'Biometric Login',
              'Use FaceID or TouchID',
              _biometricEnabled,
              (value) {
                setState(() {
                  _biometricEnabled = value;
                });
              },
              LucideIcons.fingerprint,
            ),
            const Divider(height: 40),
            _buildSectionHeader('Privacy'),
            const SizedBox(height: 16),
            _buildSettingTile(
              context,
              'Privacy Policy',
              'Read our privacy policy',
              LucideIcons.fileText,
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              'Terms of Service',
              'Read our terms of service',
              LucideIcons.fileText,
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              'Data Management',
              'Manage your data usage',
              LucideIcons.database,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
      BuildContext context, String title, String subtitle, IconData icon,
      {VoidCallback? onTap}) {
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
            color: AppColors.primaryTeal.withOpacity(0.1),
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

  Widget _buildSwitchTile(String title, String subtitle, bool value,
      ValueChanged<bool> onChanged, IconData icon) {
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
            color: AppColors.primaryTeal.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryTeal, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryTeal,
        ),
      ),
    );
  }
}
