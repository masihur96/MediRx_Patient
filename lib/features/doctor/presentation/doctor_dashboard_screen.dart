import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'doctor_home_screen.dart';
import 'doctor_patient_list_screen.dart';
import 'doctor_prescriptions_screen.dart';
import 'doctor_analytics_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DoctorHomeScreen(),
    DoctorPatientListScreen(),
    DoctorPrescriptionsScreen(),
    DoctorAnalyticsScreen(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(LucideIcons.layoutDashboard),
      selectedIcon: Icon(LucideIcons.layoutDashboard, color: AppColors.primaryTeal),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.users),
      selectedIcon: Icon(LucideIcons.users, color: AppColors.primaryTeal),
      label: 'Patients',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.fileText),
      selectedIcon: Icon(LucideIcons.fileText, color: AppColors.primaryTeal),
      label: 'Rx',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.barChart2),
      selectedIcon: Icon(LucideIcons.barChart2, color: AppColors.primaryTeal),
      label: 'Analytics',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: _destinations,
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: AppColors.primaryTeal.withOpacity(0.15),
        elevation: 4,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
