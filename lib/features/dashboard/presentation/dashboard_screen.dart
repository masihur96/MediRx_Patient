import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../ai_assistant/presentation/ai_assistant_screen.dart';
import '../../medication/presentation/medication_screen.dart';
import '../../menstrual_cycle/presentation/menstrual_cycle_screen.dart';
import '../../nearest_medical/presentation/nearest_medical_screen.dart';
import '../../pediatric_dose/presentation/pediatric_dose_screen.dart';
import '../../pregnancy/presentation/pregnancy_screen.dart';
import '../../rating/presentation/doctor_rating_screen.dart';
import '../../scheduling/presentation/scheduling_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../vaccine/presentation/vaccine_screen.dart';

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

  final List<MedicationTask> _todayMeds = [
    MedicationTask(
        id: '1', name: 'Atorvastatin', dosage: '10mg', time: '08:00 AM'),
    MedicationTask(
        id: '2', name: 'Metformin', dosage: '500mg', time: '01:00 PM'),
    MedicationTask(
        id: '3', name: 'Vitamin D3', dosage: '2000 IU', time: '08:00 PM'),
  ];



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
        IconButton(onPressed: () {}, icon: const Icon(LucideIcons.plus)),
      ];
    }
    return [
      IconButton(onPressed: () {}, icon: const Icon(LucideIcons.bell)),
      IconButton(onPressed: () {}, icon: const Icon(LucideIcons.userCircle)),
      const SizedBox(width: 8),
    ];
  }

  void _toggleMedStatus(String id) {
    setState(() {
      final med = _todayMeds.firstWhere((m) => m.id == id);
      med.isTaken = !med.isTaken;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = Provider.of<LocalizationProvider>(context);

    final screens = [
      _DashboardHomeView(
        todayMeds: _todayMeds,
        onToggleMedStatus: _toggleMedStatus,
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
    return ListTile(
      leading: Icon(icon,
          color: _selectedIndex == index ? AppColors.primaryTeal : Colors.grey),
      title: Text(title,
          style: TextStyle(
              color: _selectedIndex == index
                  ? AppColors.primaryTeal
                  : Colors.black87,
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
  final List<MedicationTask> todayMeds;
  final Function(String) onToggleMedStatus;
  final VoidCallback onViewAllTap;

  const _DashboardHomeView({
    required this.todayMeds,
    required this.onToggleMedStatus,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = Provider.of<LocalizationProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text
            Text(
              'Hello, Druvo!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Health Summary Cards
            Row(
              children: [
                _buildSummaryCard(context, 'Heart Rate', '72 bpm',
                    LucideIcons.heart, Colors.red[50]!, Colors.red),
                const SizedBox(width: 16),
                _buildSummaryCard(context, 'Steps', '4,231',
                    LucideIcons.footprints, Colors.orange[50]!, Colors.orange),
              ],
            ),
            const SizedBox(height: 32),

            // Today's Medication Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Medication',
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
            ...todayMeds
                .map((med) => _buildTodayMedCard(context, med)),

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
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayMedCard(
      BuildContext context, MedicationTask med) {
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
                color: med.isTaken
                    ? AppColors.primaryTeal.withOpacity(0.1)
                    : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.pill,
                  color: med.isTaken ? AppColors.primaryTeal : Colors.grey[400],
                  size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(med.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration:
                            med.isTaken ? TextDecoration.lineThrough : null,
                        color: med.isTaken ? Colors.grey : Colors.black87,
                      )),
                  Text('${med.dosage} • ${med.time}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            IconButton(
              onPressed: () => onToggleMedStatus(med.id),
              icon: Icon(
                med.isTaken ? LucideIcons.checkCircle2 : LucideIcons.circle,
                color: med.isTaken ? AppColors.primaryTeal : Colors.grey[300],
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

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(opacity),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text('${index + 1}',
                      style: TextStyle(
                        fontSize: 10,
                        color: opacity > 0.5 ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              );
            },
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
