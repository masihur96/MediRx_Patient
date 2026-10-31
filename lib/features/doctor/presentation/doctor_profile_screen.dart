import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../data/doctor_dummy_data.dart';
import 'doctor_settings_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
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

  String _formatDoctorName(String? rawName, String fallback) {
    if (rawName == null || rawName.trim().isEmpty) return fallback;
    final trimmed = rawName.trim();
    if (trimmed.toLowerCase().startsWith('dr.') ||
        trimmed.toLowerCase().startsWith('dr ')) {
      return trimmed;
    }
    return 'Dr. $trimmed';
  }

  String _getInitials(String? rawName) {
    if (rawName == null || rawName.trim().isEmpty) return 'DR';
    final parts = rawName.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    AppSnackBar.showSuccess(
      context,
      message: '$label copied to clipboard',
    );
  }

  @override
  Widget build(BuildContext context) {
    final fallbackDoctor = DoctorDummyData.currentDoctor;
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;
    final isDoctor = user?.isDoctor ?? true;

    final doctorName = _formatDoctorName(user?.fullName, fallbackDoctor.name);
    final initials = _getInitials(user?.fullName ?? fallbackDoctor.name);
    final email = user?.email.isNotEmpty == true ? user!.email : fallbackDoctor.email;
    final phone = (user?.phone != null && user!.phone!.trim().isNotEmpty)
        ? user.phone!.trim()
        : fallbackDoctor.phone;
    final doctorId = user?.uuid ?? (user?.id.isNotEmpty == true ? 'DOC-${user!.id}' : fallbackDoctor.id);
    final status = (user?.status?.isNotEmpty == true)
        ? user!.status![0].toUpperCase() + user.status!.substring(1)
        : 'Active';

    final hasImage = user?.profileImage != null &&
        (user!.profileImage!.startsWith('http://') ||
            user.profileImage!.startsWith('https://'));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: AppColors.primaryTeal,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primaryTeal, Color(0xFF00796B)],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 36),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 46,
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              backgroundImage:
                                  hasImage ? NetworkImage(user.profileImage!) : null,
                              child: !hasImage
                                  ? Text(
                                      initials,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.check,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              doctorName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              LucideIcons.badgeCheck,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isDoctor
                              ? fallbackDoctor.specialization
                              : 'Medical Practitioner',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.settings),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DoctorSettingsScreen()),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Doctor ID & Verification Banner
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.primaryTeal.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.shieldCheck,
                              color: AppColors.primaryTeal, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Doctor ID: $doctorId',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                                Text(
                                  'Role: ${user?.role ?? (isDoctor ? "Doctor" : "Medical Practitioner")} • Status: $status',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.copy, size: 18),
                            color: AppColors.primaryTeal,
                            tooltip: 'Copy Doctor ID',
                            onPressed: () =>
                                _copyToClipboard(doctorId, 'Doctor ID'),
                          ),
                        ],
                      ),
                    ),

                    // Stats Row
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statItem(context, '${fallbackDoctor.totalPatients}',
                              'Patients', LucideIcons.users),
                          _dividerLine(),
                          _statItem(context, fallbackDoctor.experience,
                              'Experience', LucideIcons.clock),
                          _dividerLine(),
                          _statItem(context, '${fallbackDoctor.rating}⭐',
                              'Rating', LucideIcons.star),
                        ],
                      ),
                    ),

                    // Doctor Professional Info
                    _infoCard(context, 'Professional Details', [
                      _infoRow(context, LucideIcons.user, 'Full Name',
                          user?.fullName.isNotEmpty == true ? user!.fullName : fallbackDoctor.name),
                      _infoRow(context, LucideIcons.shield, 'Role / Identity',
                          user?.role ?? (isDoctor ? 'Doctor' : 'Medical Practitioner')),
                      _infoRow(context, LucideIcons.stethoscope, 'Qualification',
                          fallbackDoctor.qualification),
                      _infoRow(context, LucideIcons.activity, 'Specialization',
                          fallbackDoctor.specialization),
                      _infoRow(context, LucideIcons.fileText, 'BMDC Reg. No.',
                          fallbackDoctor.regNo),
                      _infoRow(context, LucideIcons.building2, 'Hospital Affiliation',
                          fallbackDoctor.hospital),
                    ]),

                    const SizedBox(height: 16),

                    // Contact Info
                    _infoCard(context, 'Contact & Account', [
                      _infoRow(context, LucideIcons.mail, 'Email Address', email),
                      _infoRow(context, LucideIcons.phone, 'Phone Number', phone),
                      if (user?.id != null && user!.id.isNotEmpty)
                        _infoRow(context, LucideIcons.hash, 'Account ID', '#${user.id}'),
                      if (user?.createdAt != null)
                        _infoRow(
                          context,
                          LucideIcons.calendar,
                          'Member Since',
                          user!.createdAt!.length >= 10
                              ? user.createdAt!.substring(0, 10)
                              : user.createdAt!,
                        ),
                    ]),

                    const SizedBox(height: 16),

                    // About Doctor
                    _infoCard(context, 'About', [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          fallbackDoctor.bio,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Doctor profile editing coming soon')),
                        ),
                        icon: const Icon(LucideIcons.edit3,
                            color: Colors.white, size: 18),
                        label: const Text('Edit Profile',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          minimumSize: Size.zero,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showLogoutDialog(context),
                        icon: const Icon(LucideIcons.logOut, size: 18),
                        label: const Text('Logout',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.errorRed,
                          side: BorderSide(
                              color: AppColors.errorRed.withValues(alpha: 0.5)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          minimumSize: Size.zero,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(
      BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryTeal),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _dividerLine() {
    return Container(
      width: 1,
      height: 44,
      color: Colors.grey.withValues(alpha: 0.25),
    );
  }

  Widget _infoCard(BuildContext context, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.primaryTeal,
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryTeal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
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
        title: const Text('Logout'),
        content:
            const Text('Are you sure you want to logout from the Doctor Panel?'),
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
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
