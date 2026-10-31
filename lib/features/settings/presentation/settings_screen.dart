import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/presentation/viewmodels/auth_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = Provider.of<LocalizationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileSection(context),
          const SizedBox(height: 32),
          _buildSectionHeader(l10n.translate('preferences')),
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
          _buildSettingTile(
            l10n.translate('dark_mode'),
            themeProvider.isDark ? 'On' : 'Off',
            themeProvider.isDark ? LucideIcons.moon : LucideIcons.sun,
            isSwitch: true,
            onSwitchChanged: (val) {
              themeProvider.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          _buildSettingTile(l10n.translate('notifications'), 'On', LucideIcons.bell, isSwitch: true),
          const SizedBox(height: 32),
          _buildSectionHeader(l10n.translate('support')),
          const SizedBox(height: 16),
          _buildSettingTile(l10n.translate('help_center'), '', LucideIcons.helpCircle),
          _buildSettingTile(l10n.translate('privacy_policy'), '', LucideIcons.lock),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () => _showLogoutDialog(context),
            child: Text(l10n.translate('logout'),
                style: const TextStyle(
                    color: AppColors.errorRed, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out from MediRx?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthViewModel>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser;
    final name = (user?.fullName.trim().isNotEmpty ?? false)
        ? user!.fullName.trim()
        : 'Patient Profile';
    final id = user?.id.isNotEmpty ?? false ? user!.id : '—';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';
    final hasImage = user?.profileImage != null &&
        (user!.profileImage!.startsWith('http://') ||
            user.profileImage!.startsWith('https://'));

    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.primaryTeal,
          backgroundImage: hasImage ? NetworkImage(user.profileImage!) : null,
          child: !hasImage
              ? Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Patient ID: #$id',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildSettingTile(String title, String value, IconData icon, {VoidCallback? onTap, bool isSwitch = false, ValueChanged<bool>? onSwitchChanged}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryTeal.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryTeal, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: value.isNotEmpty ? Text(value) : null,
      trailing: isSwitch
          ? Switch(
              value: value == 'On',
              onChanged: onSwitchChanged ?? (_) {},
              activeThumbColor: AppColors.primaryTeal)
          : const Icon(LucideIcons.chevronRight, size: 18),
      onTap: onTap,
    );
  }
}
