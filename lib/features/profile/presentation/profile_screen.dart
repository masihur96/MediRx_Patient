import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:medirx_patient/features/auth/presentation/login_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../medication/presentation/medication_screen.dart';
import '../../notification/presentation/notification_screen.dart';
import '../../scheduling/presentation/scheduling_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import 'screens/health_records_screen.dart';
import 'screens/personal_information_screen.dart';
import 'screens/privacy_security_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Refresh user profile when opening profile screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfile();
    });
  }

  Future<void> _refreshProfile() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    await context.read<AuthViewModel>().fetchUserProfile();
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.logOut,
                  color: AppColors.errorRed, size: 22),
            ),
            const SizedBox(width: 12),
            const Text(
              'Log Out',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to log out from MediRx? You will need to log in again to access your health records.',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: isDark ? Colors.grey[400] : AppColors.textGray,
          ),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await context.read<AuthViewModel>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            child: const Text(
              'Log Out',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;

    final displayName = (user?.fullName.trim().isNotEmpty ?? false)
        ? user!.fullName.trim()
        : 'Patient Profile';

    final email = (user?.email.trim().isNotEmpty ?? false)
        ? user!.email.trim()
        : 'No email provided';

    final phone = (user?.phone?.trim().isNotEmpty ?? false)
        ? user!.phone!.trim()
        : 'No phone number';

    final userInitial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'P';
    final hasImage = user?.profileImage != null &&
        (user!.profileImage!.startsWith('http://') ||
            user.profileImage!.startsWith('https://'));

    final status = (user?.status?.trim().isNotEmpty ?? false)
        ? user!.status!.toUpperCase()
        : 'ACTIVE';

    final id = user?.id.isNotEmpty ?? false ? user!.id : '—';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: AppColors.primaryTeal,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero User Card ───────────────────────────────────────
              _buildUserHeroCard(
                context: context,
                isDark: isDark,
                displayName: displayName,
                email: email,
                phone: phone,
                initial: userInitial,
                hasImage: hasImage,
                imageUrl: user?.profileImage,
                status: status,
                id: id,
              ),

              const SizedBox(height: 20),

              // ── Quick Vitals / Medical Overview Row ──────────────────
              _buildQuickStatsRow(
                isDark: isDark,
                bloodGroup: user?.bloodGroup ?? 'O+',
                gender: user?.gender ?? 'Male',
                role: 'Patient',
              ),

              const SizedBox(height: 24),

              // ── Medical & Records Section ────────────────────────────
              _buildSectionHeader('Medical & Records'),
              const SizedBox(height: 10),
              _buildMenuCard(
                isDark: isDark,
                children: [
                  _buildMenuItem(
                    icon: LucideIcons.user,
                    iconColor: AppColors.primaryTeal,
                    title: 'Personal Information',
                    subtitle: 'Name, contact, DOB & gender',
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PersonalInformationScreen(),
                        ),
                      );
                      if (mounted) _refreshProfile();
                    },
                  ),
                  _buildDivider(isDark),
                  _buildMenuItem(
                    icon: LucideIcons.heartPulse,
                    iconColor: const Color(0xFFE53935),
                    title: 'Health Records',
                    subtitle: 'Medical history, allergies & lab reports',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HealthRecordsScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(isDark),
                  _buildMenuItem(
                    icon: LucideIcons.pill,
                    iconColor: const Color(0xFF00ACC1),
                    title: 'Prescriptions & Medicines',
                    subtitle: 'Digital prescriptions & dose tracking',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MedicationScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(isDark),
                  _buildMenuItem(
                    icon: LucideIcons.calendar,
                    iconColor: const Color(0xFF5E35B1),
                    title: 'Appointments',
                    subtitle: 'Upcoming visits & booking schedule',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SchedulingScreen(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Security & Preferences Section ───────────────────────
              _buildSectionHeader('Preferences & Security'),
              const SizedBox(height: 10),
              _buildMenuCard(
                isDark: isDark,
                children: [
                  _buildMenuItem(
                    icon: LucideIcons.shieldCheck,
                    iconColor: const Color(0xFF43A047),
                    title: 'Privacy & Security',
                    subtitle: 'Password, biometric & account security',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacySecurityScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(isDark),
                  _buildMenuItem(
                    icon: LucideIcons.bell,
                    iconColor: const Color(0xFFFB8C00),
                    title: 'Notifications',
                    subtitle: 'Medicine reminders & appointment alerts',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(isDark),
                  _buildMenuItem(
                    icon: LucideIcons.settings,
                    iconColor: const Color(0xFF546E7A),
                    title: 'Settings',
                    subtitle: 'Language, dark theme & app preferences',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Log Out Action Button ────────────────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.errorRed.withValues(alpha: 0.08),
                  border: Border.all(
                    color: AppColors.errorRed.withValues(alpha: 0.25),
                  ),
                ),
                child: InkWell(
                  onTap: () => _showLogoutConfirmation(context),
                  borderRadius: BorderRadius.circular(16),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.logOut,
                            color: AppColors.errorRed, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Log Out of MediRx',
                          style: TextStyle(
                            color: AppColors.errorRed,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Version / App Info Footer
              Center(
                child: Text(
                  'MediRx Patient v1.0.0 • Secure Healthcare',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero User Card Widget ───────────────────────────────────────────
  Widget _buildUserHeroCard({
    required BuildContext context,
    required bool isDark,
    required String displayName,
    required String email,
    required String phone,
    required String initial,
    required bool hasImage,
    required String? imageUrl,
    required String status,
    required String id,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : AppColors.primaryTeal.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black26
                : AppColors.primaryTeal.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with status ring
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryTeal.withValues(alpha: 0.25),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.primaryTeal,
                      backgroundImage:
                          hasImage ? NetworkImage(imageUrl!) : null,
                      child: !hasImage
                          ? Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                  // Active status green dot
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.successGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Name, status, and ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).textTheme.headlineMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Active badge and ID Chip
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color:
                                AppColors.successGreen.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.successGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                status,
                                style: const TextStyle(
                                  color: AppColors.successGreen,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Copyable Patient ID Chip
                        GestureDetector(
                          onTap: () {
                            if (id != '—') {
                              Clipboard.setData(ClipboardData(text: id));
                              AppSnackBar.showSuccess(
                                context,
                                message: 'Patient ID copied to clipboard: #$id',
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryTeal.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'ID: #',
                                  style: TextStyle(
                                    color: AppColors.primaryTeal,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  id,
                                  style: const TextStyle(
                                    color: AppColors.primaryTeal,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Icon(
                                  LucideIcons.copy,
                                  size: 10,
                                  color: AppColors.primaryTeal,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: isDark ? Colors.white12 : Colors.grey[200], height: 1),
          const SizedBox(height: 14),

          // Contact Information Details
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(LucideIcons.mail,
                          size: 14, color: AppColors.primaryTeal),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[300] : AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(LucideIcons.phone,
                          size: 14, color: AppColors.primaryTeal),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        phone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[300] : AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Quick Vitals Row ─────────────────────────────────────────────────
  Widget _buildQuickStatsRow({
    required bool isDark,
    required String bloodGroup,
    required String gender,
    required String role,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            isDark: isDark,
            label: 'Blood Group',
            value: bloodGroup,
            icon: LucideIcons.droplet,
            color: const Color(0xFFE53935),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            isDark: isDark,
            label: 'Gender',
            value: gender,
            icon: LucideIcons.user,
            color: const Color(0xFF1E88E5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            isDark: isDark,
            label: 'Role',
            value: role,
            icon: LucideIcons.shield,
            color: AppColors.primaryTeal,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required bool isDark,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey[400] : AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }

  // ── Menu Section & Items ─────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppColors.textGray,
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 54,
      endIndent: 16,
      color: isDark ? Colors.white10 : Colors.grey[100],
    );
  }
}
