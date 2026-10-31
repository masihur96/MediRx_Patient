import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../ai_assistant/presentation/ai_assistant_screen.dart';
import '../../blood_bank/presentation/blood_bank_screen.dart';
import '../../medication/presentation/medication_screen.dart';
import '../../menstrual_cycle/presentation/menstrual_cycle_screen.dart';
import '../../nearest_medical/presentation/nearest_medical_screen.dart';
import '../../notification/presentation/notification_screen.dart';
import '../../pediatric_dose/presentation/pediatric_dose_screen.dart';
import '../../pregnancy/presentation/pregnancy_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../rating/presentation/doctor_rating_screen.dart';
import '../../scheduling/presentation/scheduling_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../vaccine/presentation/vaccine_screen.dart';
import '../presentation/viewmodels/dashboard_viewmodel.dart';

class MedicationTask {
  final String id;
  final String name;
  final String dosage;
  final String time;
  bool isTaken;

  MedicationTask({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    this.isTaken = false,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().fetchDashboardOverview();
    });
  }

  String _getAppBarTitle(BuildContext context, LocalizationProvider l10n) {
    switch (_selectedIndex) {
      case 0:
        return l10n.translate('app_name');
      case 1:
        return l10n.translate('medication');
      case 2:
        return l10n.translate('scheduling');
      case 3:
        return l10n.translate('ai_doctor');
      default:
        return l10n.translate('app_name');
    }
  }

  List<Widget> _getAppBarActions() {
    if (_selectedIndex == 1) {
      // Medication tab
      return [
        IconButton(
          onPressed: () => MedicationScreen.showAddPrescriptionOptions(context),
          icon: const Icon(LucideIcons.plus),
        ),
      ];
    }
    return [
      IconButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()));
        },
        icon: const Icon(LucideIcons.bell),
      ),
      IconButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()));
        },
        icon: const Icon(LucideIcons.userCircle),
      ),
      const SizedBox(width: 8),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = Provider.of<LocalizationProvider>(context);

    final screens = [
      _DashboardHomeView(
        onViewAllTap: () => setState(() => _selectedIndex = 1),
      ),
      const MedicationScreen(isTab: true),
      const SchedulingScreen(isTab: true),
      const AiAssistantScreen(isTab: true),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(context, l10n),
            style: _selectedIndex == 0
                ? Theme.of(context).textTheme.headlineMedium
                : null),
        elevation: _selectedIndex == 0 ? 0 : null,
        backgroundColor: _selectedIndex == 0 ? Colors.transparent : null,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(LucideIcons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: _getAppBarActions(),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(LucideIcons.home),
            selectedIcon:
                const Icon(LucideIcons.home, color: AppColors.primaryTeal),
            label: l10n.translate('home'),
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.pill),
            selectedIcon:
                const Icon(LucideIcons.pill, color: AppColors.primaryTeal),
            label: l10n.translate('medication'),
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.calendar),
            selectedIcon:
                const Icon(LucideIcons.calendar, color: AppColors.primaryTeal),
            label: l10n.translate('scheduling'),
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.bot),
            selectedIcon:
                const Icon(LucideIcons.bot, color: AppColors.primaryTeal),
            label: l10n.translate('ai_doctor'),
          ),
        ],
      ),
      drawer: _buildDrawer(context, l10n),
    );
  }

  Widget _buildDrawer(BuildContext context, LocalizationProvider l10n) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryTeal,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(LucideIcons.user,
                        color: AppColors.primaryTeal, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.translate('app_name'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(LucideIcons.home, l10n.translate('home'), 0),
                _buildDrawerItem(
                    LucideIcons.pill, l10n.translate('medication'), 1),
                _buildDrawerItem(
                    LucideIcons.calendar, l10n.translate('scheduling'), 2),
                _buildDrawerItem(
                    LucideIcons.bot, l10n.translate('ai_doctor'), 3),
                const Divider(),
                _buildDrawerNavigateItem(
                    LucideIcons.syringe,
                    l10n.translate('vaccine'),
                    Colors.amber,
                    const VaccineScreen()),
                _buildDrawerNavigateItem(
                    LucideIcons.mapPin,
                    l10n.translate('nearest_medical'),
                    Colors.green,
                    const NearestMedicalScreen()),
                _buildDrawerNavigateItem(
                    LucideIcons.baby,
                    l10n.translate('pediatric_dose'),
                    Colors.pink,
                    const PediatricDoseScreen()),
                _buildDrawerNavigateItem(
                    LucideIcons.baby,
                    l10n.translate('pregnancy'),
                    Colors.pinkAccent,
                    const PregnancyScreen()),
                _buildDrawerNavigateItem(
                    LucideIcons.wheatOff,
                    l10n.translate('menstrual_cycle'),
                    Colors.redAccent,
                    const MenstrualCycleScreen()),
                _buildDrawerNavigateItem(
                    LucideIcons.star,
                    l10n.translate('doctor_rating'),
                    Colors.indigo,
                    const DoctorRatingScreen()),
                _buildDrawerNavigateItem(
                    Icons.bloodtype_rounded,
                    'Blood Bank',
                    Colors.red,
                    const BloodBankScreen()),
                const Divider(),
                _buildDrawerNavigateItem(
                    LucideIcons.settings,
                    l10n.translate('settings'),
                    Colors.grey,
                    const SettingsScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon,
          color: _selectedIndex == index ? AppColors.primaryTeal : Colors.grey),
      title: Text(title,
          style: TextStyle(
              color: _selectedIndex == index
                  ? AppColors.primaryTeal
                  : (isDark ? Colors.white70 : Colors.black87),
              fontWeight: _selectedIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal)),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildDrawerNavigateItem(
      IconData icon, String title, Color color, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }
}

class _DashboardHomeView extends StatelessWidget {
  final VoidCallback onViewAllTap;

  const _DashboardHomeView({
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = Provider.of<LocalizationProvider>(context);

    return Consumer<DashboardViewModel>(
      builder: (context, dashVm, _) {
        final greeting = dashVm.patient?['greeting']?.toString() ??
            'Welcome back!';
        final healthId = dashVm.patient?['healthId']?.toString() ?? '';
        final adherence = dashVm.adherenceRate;
        final stats = dashVm.quickStats;
        final todayMeds = dashVm.todayMedications;

        return RefreshIndicator(
          onRefresh: () => dashVm.refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting card
                  _buildGreetingCard(context, greeting, healthId, adherence),
                  const SizedBox(height: 20),

                  // Quick Stats
                  if (stats != null) ...[
                    _buildQuickStats(context, stats),
                    const SizedBox(height: 24),
                  ],

                  _buildVitalsChart(context),
                  const SizedBox(height: 28),

                  // Today's Medication Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Medication",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: onViewAllTap,
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (dashVm.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (todayMeds.isEmpty)
                    _buildNoMedsCard(context)
                  else
                    ...todayMeds.map((med) =>
                        _buildLiveMedCard(context, med as Map<String, dynamic>)),

                  const SizedBox(height: 32),

                  // Medication History Heatmap
            Text(
              'Medication History',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 16),
            _buildHeatmap(context),

            const SizedBox(height: 32),

            // Modules Grid
            Text(
              'Other Services',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildModuleCard(context, l10n.translate('vaccine'),
                    LucideIcons.syringe, Colors.amber, onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const VaccineScreen()));
                }),
                _buildModuleCard(context, l10n.translate('nearest_medical'),
                    LucideIcons.mapPin, Colors.green, onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NearestMedicalScreen()));
                }),
                _buildModuleCard(context, l10n.translate('pediatric_dose'),
                    LucideIcons.baby, Colors.pink, onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PediatricDoseScreen()));
                }),
                _buildModuleCard(context, l10n.translate('pregnancy'),
                    LucideIcons.baby, Colors.pinkAccent, onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PregnancyScreen()));
                }),
                _buildModuleCard(context, l10n.translate('menstrual_cycle'),
                    LucideIcons.wheatOff, Colors.redAccent, onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MenstrualCycleScreen()));
                }),
                _buildModuleCard(context, l10n.translate('doctor_rating'),
                    LucideIcons.star, Colors.indigo, onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DoctorRatingScreen()));
                }),
                _buildModuleCard(
                    context, 'Blood Bank', Icons.bloodtype_rounded, Colors.red,
                    onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BloodBankScreen()));
                }),
              ],
            ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGreetingCard(BuildContext context, String greeting,
      String healthId, num adherence) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryTeal, Color(0xFF0E9E8E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (healthId.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('Health ID: $healthId',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(LucideIcons.activity,
                  color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text('Adherence: ${adherence.toStringAsFixed(0)}%',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: adherence / 100,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
      BuildContext context, Map<String, dynamic> stats) {
    return Row(
      children: [
        _buildStatChip(
          context,
          LucideIcons.fileText,
          '${stats['activePrescriptions'] ?? 0}',
          'Prescriptions',
          AppColors.primaryTeal,
        ),
        const SizedBox(width: 10),
        _buildStatChip(
          context,
          LucideIcons.calendar,
          '${stats['upcomingAppointments'] ?? 0}',
          'Appointments',
          Colors.blue,
        ),
        const SizedBox(width: 10),
        _buildStatChip(
          context,
          LucideIcons.syringe,
          '${stats['pendingVaccinations'] ?? 0}',
          'Vaccines',
          Colors.amber,
        ),
      ],
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String value,
      String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: color)),
            Text(label,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMedsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          Icon(LucideIcons.checkCircle, color: Colors.green, size: 28),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("You're all done!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
                Text("No medications scheduled for today.",
                    style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMedCard(
      BuildContext context, Map<String, dynamic> med) {
    final name = med['medicine_name']?.toString() ??
        med['medicineName']?.toString() ??
        med['name']?.toString() ??
        'Medication';
    final dose = med['dosage']?.toString() ??
        med['dose']?.toString() ??
        '';
    final scheduledTime = med['scheduled_time']?.toString() ??
        med['time']?.toString() ??
        '';
    final status = med['status']?.toString() ?? 'pending';
    final isTaken = status == 'taken';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isTaken
                    ? AppColors.primaryTeal.withValues(alpha: 0.1)
                    : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.pill,
                  color: isTaken
                      ? AppColors.primaryTeal
                      : Colors.grey[400],
                  size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration:
                            isTaken ? TextDecoration.lineThrough : null,
                        color: isTaken
                            ? Colors.grey
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      )),
                  Text(
                    [if (dose.isNotEmpty) dose, if (scheduledTime.isNotEmpty) scheduledTime]
                        .join(' • '),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isTaken
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isTaken ? 'Taken' : 'Pending',
                style: TextStyle(
                  fontSize: 11,
                  color: isTaken ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmap(BuildContext context) {
    // Mock heatmap grid
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('February 2026',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  _buildLegendDot(AppColors.primaryTeal.withOpacity(0.1)),
                  const SizedBox(width: 4),
                  _buildLegendDot(AppColors.primaryTeal.withOpacity(0.4)),
                  const SizedBox(width: 4),
                  _buildLegendDot(AppColors.primaryTeal),
                  const SizedBox(width: 8),
                  const Text('Consistency',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 28, // February
            itemBuilder: (context, index) {
              // Mock consistency levels
              double opacity = 0.1;
              if (index < 5)
                opacity = 1.0;
              else if (index < 10)
                opacity = 0.4;
              else if (index < 15)
                opacity = 0.8;
              else if (index == 20) opacity = 0.1;

              return Material(
                color: AppColors.primaryTeal.withOpacity(opacity),
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                  onTap: () => _showDateDetails(context, index + 1),
                  borderRadius: BorderRadius.circular(4),
                  child: Center(
                    child: Text('${index + 1}',
                        style: TextStyle(
                          fontSize: 10,
                          color: opacity > 0.5 
                              ? Colors.white 
                              : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDateDetails(BuildContext context, int day) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'February $day, 2026',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Medication History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // Mock history list
              _buildHistoryItem(
                  'Atorvastatin', '10mg', '08:00 AM', true), // Taken
              _buildHistoryItem(
                  'Metformin', '500mg', '01:00 PM', true), // Taken
              _buildHistoryItem(
                  'Vitamin D3', '2000 IU', '08:00 PM', false), // Missed
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryItem(
      String name, String dosage, String time, bool isTaken) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            isTaken ? LucideIcons.checkCircle2 : LucideIcons.xCircle,
            color: isTaken ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$dosage • $time',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Text(
            isTaken ? 'Taken' : 'Missed',
            style: TextStyle(
              color: isTaken ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value,
      IconData icon, Color bgColor, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 12),
            Text(value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title,
                style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard(BuildContext context, String title, String value,
      IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title,
              style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildVitalsChart(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vitals Trend (Last 7 Days)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildLegendItem('HR', Colors.red),
              _buildLegendItem('BP(Sys)', Colors.blue),
              _buildLegendItem('SpO2', Colors.cyan),
              _buildLegendItem('Glucose', Colors.purple),
              _buildLegendItem('Temp', Colors.orange),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 6,
                minY: 20,
                maxY: 140,
                lineTouchData: const LineTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        );
                        int dayNumber = value.toInt() + 1;
                        if (dayNumber >= 1 && dayNumber <= 7) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Text('Day $dayNumber', style: style),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 120,
                      color: Colors.blue.withOpacity(0.5),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(show: true, alignment: Alignment.topRight, padding: const EdgeInsets.only(right: 5, bottom: 5), labelResolver: (_) => 'BP (90-120)', style: const TextStyle(fontSize: 9, color: Colors.blue)),
                    ),
                    HorizontalLine(
                      y: 100,
                      color: Colors.purple.withOpacity(0.5),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(show: true, alignment: Alignment.topRight, padding: const EdgeInsets.only(right: 5, bottom: 5), labelResolver: (_) => 'Glucose (70-100)', style: const TextStyle(fontSize: 9, color: Colors.purple)),
                    ),
                    HorizontalLine(
                      y: 95,
                      color: Colors.cyan.withOpacity(0.5),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(show: true, alignment: Alignment.bottomRight, padding: const EdgeInsets.only(right: 5, top: 5), labelResolver: (_) => 'SpO2 (95-100%)', style: const TextStyle(fontSize: 9, color: Colors.cyan)),
                    ),
                    HorizontalLine(
                      y: 80,
                      color: Colors.red.withOpacity(0.5),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(show: true, alignment: Alignment.topRight, padding: const EdgeInsets.only(right: 5, bottom: 5), labelResolver: (_) => 'HR (60-100)', style: const TextStyle(fontSize: 9, color: Colors.red)),
                    ),
                    HorizontalLine(
                      y: 37,
                      color: Colors.orange.withOpacity(0.5),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(show: true, alignment: Alignment.topRight, padding: const EdgeInsets.only(right: 5, bottom: 5), labelResolver: (_) => 'Temp (36.5-37.5)', style: const TextStyle(fontSize: 9, color: Colors.orange)),
                    ),
                  ],
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 30,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[300],
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Heart Rate
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 72), FlSpot(1, 75), FlSpot(2, 71),
                      FlSpot(3, 78), FlSpot(4, 73), FlSpot(5, 70), FlSpot(6, 72),
                    ],
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                  // Blood Pressure
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 120), FlSpot(1, 118), FlSpot(2, 122),
                      FlSpot(3, 119), FlSpot(4, 125), FlSpot(5, 121), FlSpot(6, 120),
                    ],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                  // SpO2
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 98), FlSpot(1, 97), FlSpot(2, 99),
                      FlSpot(3, 98), FlSpot(4, 98), FlSpot(5, 99), FlSpot(6, 98),
                    ],
                    isCurved: true,
                    color: Colors.cyan,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                  // Glucose
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 95), FlSpot(1, 105), FlSpot(2, 92),
                      FlSpot(3, 110), FlSpot(4, 98), FlSpot(5, 88), FlSpot(6, 95),
                    ],
                    isCurved: true,
                    color: Colors.purple,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                  // Temperature
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 36.5), FlSpot(1, 36.6), FlSpot(2, 36.4),
                      FlSpot(3, 36.7), FlSpot(4, 37.0), FlSpot(5, 36.5), FlSpot(6, 36.5),
                    ],
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildModuleCard(
      BuildContext context, String title, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
