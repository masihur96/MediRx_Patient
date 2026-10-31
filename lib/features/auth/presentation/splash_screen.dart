import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/storage_service.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../doctor/presentation/doctor_dashboard_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'viewmodels/auth_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    final startTime = DateTime.now();
    final authViewModel = context.read<AuthViewModel>();
    final token = await StorageService.getToken();

    Widget targetScreen;

    if (token != null && token.isNotEmpty) {
      // User is already logged in -> fetch fresh user data from GET /user
      await authViewModel.fetchUserProfile(token: token);

      final user = authViewModel.currentUser ??
          await authViewModel.getCurrentUser();

      if (user != null) {
        // Navigate role-wise to dashboard (no onboard flow)
        targetScreen = user.isDoctor
            ? const DoctorDashboardScreen()
            : const DashboardScreen();
      } else {
        // Token was invalid / expired and no user could be loaded
        await StorageService.logout();
        targetScreen = const LoginScreen();
      }
    } else {
      // User is not logged in: check if first run
      final isFirst = await StorageService.isFirstRun();
      if (isFirst) {
        targetScreen = const OnboardingScreen();
      } else {
        targetScreen = const LoginScreen();
      }
    }

    // Keep splash on screen for a smooth minimum time
    final elapsed = DateTime.now().difference(startTime);
    const minSplashDuration = Duration(milliseconds: 1800);
    if (elapsed < minSplashDuration) {
      await Future.delayed(minSplashDuration - elapsed);
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => targetScreen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryTeal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const MediRxLogo(
              size: 120,
              showText: false,
              color: Colors.white,
            ),

            const SizedBox(height: 24),

            // Bottom text
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                'MediRx - Empowering Healthcare.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
