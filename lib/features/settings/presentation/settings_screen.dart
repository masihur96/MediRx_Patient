import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileSection(),
          const SizedBox(height: 32),
          _buildSectionHeader('Preferences'),
          const SizedBox(height: 16),
          _buildSettingTile(
            l10n.translate('language'),
            l10n.language == AppLanguage.en ? 'English' : 'বাংলা',
            LucideIcons.globe,
            onTap: () {
              l10n.setLanguage(
                l10n.language == AppLanguage.en ? AppLanguage.bn : AppLanguage.en
              );
            },
          ),
          _buildSettingTile('Dark Mode', 'Off', LucideIcons.moon, isSwitch: true),
          _buildSettingTile('Notifications', 'On', LucideIcons.bell, isSwitch: true),
          const SizedBox(height: 32),
          _buildSectionHeader('Support'),
          const SizedBox(height: 16),
          _buildSettingTile('Help Center', '', LucideIcons.helpCircle),
          _buildSettingTile('Privacy Policy', '', LucideIcons.lock),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {},
            child: const Text('Log Out', style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=patient'),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('John Doe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Patient ID: RX-987654', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(LucideIcons.edit3, color: AppColors.primaryTeal)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildSettingTile(String title, String value, IconData icon, {VoidCallback? onTap, bool isSwitch = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryTeal.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryTeal, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: value.isNotEmpty ? Text(value) : null,
      trailing: isSwitch 
        ? Switch(value: value == 'On', onChanged: (_) {}, activeColor: AppColors.primaryTeal)
        : const Icon(LucideIcons.chevronRight, size: 18),
      onTap: onTap,
    );
  }
}
