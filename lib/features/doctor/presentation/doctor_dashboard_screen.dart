import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'doctor_home_screen.dart';
import 'doctor_patient_list_screen.dart';
import 'doctor_prescriptions_screen.dart';
import 'doctor_analytics_screen.dart';
import 'doctor_settings_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _zoomDrawerController,
      style: DrawerStyle.defaultStyle,
      menuScreen: const DoctorMenuScreen(),
      mainScreen: _DoctorMainScreen(zoomDrawerController: _zoomDrawerController),
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      menuBackgroundColor: AppColors.primaryTeal,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }
}

class _DoctorMainScreen extends StatefulWidget {
  final ZoomDrawerController zoomDrawerController;
  
  const _DoctorMainScreen({required this.zoomDrawerController});

  @override
  State<_DoctorMainScreen> createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<_DoctorMainScreen> {
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

class DoctorMenuScreen extends StatelessWidget {
  const DoctorMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryTeal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(LucideIcons.user, size: 40, color: AppColors.primaryTeal),
              ),
              const SizedBox(height: 20),
              const Text(
                'Dr. Sarah',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Cardiologist',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              
              _buildMenuItem(context, LucideIcons.layoutDashboard, 'Dashboard', () {
                ZoomDrawer.of(context)?.close();
              }),
              _buildMenuItem(context, LucideIcons.settings, 'Settings', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorSettingsScreen()));
              }),
              
              const Spacer(),
              _buildMenuItem(context, LucideIcons.logOut, 'Logout', () {
                Navigator.of(context).pushReplacementNamed('/'); // Assume we have a root login route or just pop all
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
