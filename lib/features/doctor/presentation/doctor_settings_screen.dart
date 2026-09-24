import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/theme_provider.dart';
import '../data/doctor_models.dart';

class DoctorSettingsScreen extends StatefulWidget {
  const DoctorSettingsScreen({super.key});

  @override
  State<DoctorSettingsScreen> createState() => _DoctorSettingsScreenState();
}

class _DoctorSettingsScreenState extends State<DoctorSettingsScreen> {
  final List<NotificationSetting> _notifications = [
    NotificationSetting(id: 'n1', title: 'New Patient Registration', subtitle: 'Get notified when a new patient is added', isEnabled: true),
    NotificationSetting(id: 'n2', title: 'Low Adherence Alerts', subtitle: 'Alert when patient adherence drops below 60%', isEnabled: true),
    NotificationSetting(id: 'n3', title: 'Lab Results Ready', subtitle: 'Notify when patient lab results are uploaded', isEnabled: true),
    NotificationSetting(id: 'n4', title: 'Prescription Expiry', subtitle: 'Remind 3 days before prescription expires', isEnabled: false),
    NotificationSetting(id: 'n5', title: 'Appointment Reminders', subtitle: 'Daily reminder for scheduled appointments', isEnabled: true),
    NotificationSetting(id: 'n6', title: 'System Updates', subtitle: 'Get notified about MediRx app updates', isEnabled: false),
  ];

  @override
  Widget build(BuildContext context) {
    final locProvider = Provider.of<LocalizationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          locProvider.translate('settings'),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─── Language Section ────────────────────────────────────────────────
          _buildSectionHeader(context, locProvider.translate('preferences'), LucideIcons.sliders),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            child: Column(
              children: [
                // Language Toggle
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _iconBox(LucideIcons.globe, Colors.blue),
                  title: Text(locProvider.translate('language'), style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(locProvider.language == AppLanguage.en ? 'English' : 'বাংলা'),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _langToggleButton(
                          'EN',
                          locProvider.language == AppLanguage.en,
                          () => locProvider.setLanguage(AppLanguage.en),
                        ),
                        _langToggleButton(
                          'বাং',
                          locProvider.language == AppLanguage.bn,
                          () => locProvider.setLanguage(AppLanguage.bn),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                // Theme Toggle
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _iconBox(
                    isDark ? LucideIcons.moon : LucideIcons.sun,
                    isDark ? Colors.indigo : Colors.amber,
                  ),
                  title: Text(locProvider.translate('dark_mode'), style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(_themeLabel(themeProvider.themeMode)),
                  trailing: DropdownButton<ThemeMode>(
                    value: themeProvider.themeMode,
                    underline: const SizedBox(),
                    onChanged: (mode) {
                      if (mode != null) themeProvider.setThemeMode(mode);
                    },
                    items: const [
                      DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                      DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ─── Notification Settings ───────────────────────────────────────────
          _buildSectionHeader(context, locProvider.translate('notifications'), LucideIcons.bell),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            child: Column(
              children: _notifications.asMap().entries.map((e) {
                final notif = e.value;
                final isLast = e.key == _notifications.length - 1;
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _iconBox(
                        LucideIcons.bell,
                        notif.isEnabled ? AppColors.primaryTeal : Colors.grey,
                      ),
                      title: Text(notif.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(notif.subtitle, style: const TextStyle(fontSize: 12)),
                      trailing: Switch(
                        value: notif.isEnabled,
                        activeColor: AppColors.primaryTeal,
                        onChanged: (v) => setState(() => notif.isEnabled = v),
                      ),
                    ),
                    if (!isLast) const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // ─── Privacy & Security ──────────────────────────────────────────────
          _buildSectionHeader(context, 'Privacy & Security', LucideIcons.shield),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            child: Column(
              children: [
                _settingsTile(context, LucideIcons.lock, 'Change Password', Colors.orange, () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Change password coming soon')))),
                const Divider(height: 1),
                _settingsTile(context, LucideIcons.fingerprint, 'Biometric Login', Colors.purple, () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biometric login coming soon')))),
                const Divider(height: 1),
                _settingsTile(context, LucideIcons.shieldCheck, 'Two-Factor Auth', AppColors.primaryTeal, () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('2FA setup coming soon')))),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ─── Prescription Defaults ───────────────────────────────────────────
          _buildSectionHeader(context, 'Prescription Defaults', LucideIcons.fileText),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            child: Column(
              children: [
                _settingsTile(context, LucideIcons.clipboard, 'Default Frequency', Colors.teal, () => _showDefaultFrequencyDialog(context)),
                const Divider(height: 1),
                _settingsTile(context, LucideIcons.clock, 'Default Duration', Colors.cyan, () => _showDefaultDurationDialog(context)),
                const Divider(height: 1),
                _settingsTile(context, LucideIcons.fileSignature, 'Prescription Header', Colors.deepPurple, () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prescription header customization coming soon')))),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ─── About ───────────────────────────────────────────────────────────
          _buildSectionHeader(context, 'About', LucideIcons.info),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            child: Column(
              children: [
                _settingsTile(context, LucideIcons.heartPulse, 'About MediRx', AppColors.primaryTeal, () => _showAboutDialog(context)),
                const Divider(height: 1),
                _settingsTile(context, LucideIcons.fileText, 'Terms & Conditions', Colors.grey, () {}),
                const Divider(height: 1),
                _settingsTile(context, LucideIcons.shield, 'Privacy Policy', Colors.grey, () {}),
                const Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _iconBox(LucideIcons.tag, Colors.grey),
                  title: const Text('Version', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ─── Logout ──────────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 32),
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(LucideIcons.logOut, size: 18),
              label: const Text('Logout from Doctor Panel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.errorRed,
                side: BorderSide(color: AppColors.errorRed.withOpacity(0.5)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                minimumSize: Size.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryTeal),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 14,
            color: AppColors.primaryTeal,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: child,
    );
  }

  Widget _settingsTile(BuildContext context, IconData icon, String title, Color iconColor, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: _iconBox(icon, iconColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      trailing: const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _iconBox(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }

  Widget _langToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTeal : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryTeal,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Follow system';
      case ThemeMode.light:
        return 'Light mode';
      case ThemeMode.dark:
        return 'Dark mode';
    }
  }

  void _showDefaultFrequencyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Default Frequency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...['Once daily', 'Twice daily', 'Three times daily'].map((f) => ListTile(
              title: Text(f),
              trailing: const Icon(LucideIcons.chevronRight, size: 16),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Default frequency set to $f')));
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showDefaultDurationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Default Duration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...['7 days', '14 days', '1 month'].map((d) => ListTile(
              title: Text(d),
              trailing: const Icon(LucideIcons.chevronRight, size: 16),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Default duration set to $d')));
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.heartPulse, color: AppColors.primaryTeal, size: 32),
            ),
            const SizedBox(height: 16),
            const Text('MediRx Doctor Panel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            const Text(
              'MediRx Doctor Panel helps physicians manage patients, create digital prescriptions, track medication adherence, and analyze practice statistics.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close', style: TextStyle(color: AppColors.primaryTeal)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
