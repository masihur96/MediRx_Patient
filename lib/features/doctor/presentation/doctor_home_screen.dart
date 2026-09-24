import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../data/doctor_dummy_data.dart';
import '../data/doctor_models.dart';
import 'doctor_patient_detail_screen.dart';
import 'doctor_profile_screen.dart';
import 'doctor_settings_screen.dart';
import 'doctor_create_prescription_screen.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = DoctorDummyData.currentDoctor;
    final recentPrescriptions = DoctorDummyData.prescriptions.take(3).toList();
    final analytics = DoctorDummyData.analytics;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, doctor),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoctorHeader(context, doctor),
                  const SizedBox(height: 24),
                  _buildStatsRow(context, analytics),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  _buildTodaySchedule(context),
                  const SizedBox(height: 24),
                  _buildRecentPrescriptions(context, recentPrescriptions),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, DoctorProfile doctor) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryTeal, Color(0xFF00796B)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(LucideIcons.heartPulse, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            'MediRx Doctor',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              color: AppColors.primaryTeal,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.bell),
          onPressed: () => _showNotifications(context),
        ),
        IconButton(
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryTeal.withOpacity(0.2),
            child: Text(
              doctor.name.split(' ')[1][0],
              style: const TextStyle(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DoctorProfileScreen()),
          ),
        ),
        IconButton(
          icon: const Icon(LucideIcons.settings),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DoctorSettingsScreen()),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildDoctorHeader(BuildContext context, DoctorProfile doctor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryTeal, Color(0xFF00897B)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              'AR',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  doctor.qualification,
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
                ),
                Text(
                  doctor.specialization,
                  style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(LucideIcons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${doctor.rating}  •  ${doctor.totalPatients} patients',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, DoctorAnalytics analytics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Total Rx',
                value: '${analytics.totalPrescriptions}',
                icon: LucideIcons.fileText,
                color: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Active Patients',
                value: '${analytics.activePatients}',
                icon: LucideIcons.users,
                color: const Color(0xFF5C6BC0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'This Month',
                value: '${analytics.thisMonthPrescriptions} Rx',
                icon: LucideIcons.calendar,
                color: const Color(0xFF26A69A),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Avg Adherence',
                value: '${analytics.avgAdherence.toInt()}%',
                icon: LucideIcons.trendingUp,
                color: const Color(0xFF66BB6A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _QuickAction(
              icon: LucideIcons.filePlus,
              label: 'New Rx',
              color: AppColors.primaryTeal,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DoctorCreatePrescriptionScreen()),
              ),
            ),
            const SizedBox(width: 12),
            _QuickAction(
              icon: LucideIcons.userPlus,
              label: 'Add Patient',
              color: const Color(0xFF5C6BC0),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add Patient feature coming soon')),
              ),
            ),
            const SizedBox(width: 12),
            _QuickAction(
              icon: LucideIcons.clipboardList,
              label: 'My Notes',
              color: const Color(0xFF26A69A),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Clinical Notes - navigate to patient for notes')),
              ),
            ),
            const SizedBox(width: 12),
            _QuickAction(
              icon: LucideIcons.share2,
              label: 'Share Rx',
              color: const Color(0xFF66BB6A),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Select a prescription first to share')),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodaySchedule(BuildContext context) {
    final appointments = [
      {'time': '09:00 AM', 'patient': 'Rahim Ahmed', 'type': 'Follow-up', 'id': 'pat-001'},
      {'time': '10:30 AM', 'patient': 'Fatima Begum', 'type': 'Consultation', 'id': 'pat-002'},
      {'time': '12:00 PM', 'patient': 'Sara Islam', 'type': 'Review', 'id': 'pat-004'},
      {'time': '02:00 PM', 'patient': 'Nabil Hassan', 'type': 'Lab Review', 'id': 'pat-005'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Schedule",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
            ),
            Text(
              '${appointments.length} appointments',
              style: const TextStyle(color: AppColors.primaryTeal, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...appointments.map((apt) => _buildAppointmentTile(context, apt)),
      ],
    );
  }

  Widget _buildAppointmentTile(BuildContext context, Map<String, String> apt) {
    final patient = DoctorDummyData.patients.firstWhere(
      (p) => p.id == apt['id'],
      orElse: () => DoctorDummyData.patients.first,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DoctorPatientDetailScreen(patient: patient)),
        ),
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            Container(
              width: 52,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                apt['time']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primaryTeal,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryTeal.withOpacity(0.15),
              child: Text(
                patient.avatarInitials,
                style: const TextStyle(
                  color: AppColors.primaryTeal,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apt['patient']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    apt['type']!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'View',
                style: TextStyle(color: AppColors.primaryTeal, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPrescriptions(BuildContext context, List<PrescriptionModel> prescriptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Prescriptions',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),
        ...prescriptions.map((rx) => _buildRxTile(context, rx)),
      ],
    );
  }

  Widget _buildRxTile(BuildContext context, PrescriptionModel rx) {
    final isActive = rx.status == 'active';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryTeal.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              LucideIcons.fileText,
              color: isActive ? AppColors.primaryTeal : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rx.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(
                  '${rx.items.length} medicines • ${_formatDate(rx.date)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isActive ? 'Active' : 'Completed',
              style: TextStyle(
                color: isActive ? Colors.green : Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _notifTile('Lab results ready', 'Nabil Hassan - KFT results uploaded', LucideIcons.fileSearch, Colors.blue),
            _notifTile('Prescription renewal', 'Rahim Ahmed medication expires in 3 days', LucideIcons.alertCircle, Colors.orange),
            _notifTile('Low adherence alert', 'Karim Khan adherence dropped to 61%', LucideIcons.trendingDown, Colors.red),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _notifTile(String title, String subtitle, IconData icon, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    );
  }
}

// ─── Stat Card Widget ────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Action Widget ─────────────────────────────────────────────────────

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
