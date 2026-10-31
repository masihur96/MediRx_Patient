import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../doctor/presentation/doctor_dashboard_screen.dart';
import 'viewmodels/auth_viewmodel.dart';

class LoginSuccessScreen extends StatefulWidget {
  final String identifier;
  final bool isEmail;

  const LoginSuccessScreen({
    super.key,
    required this.identifier,
    required this.isEmail,
  });

  @override
  State<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends State<LoginSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<double> _checkAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    // Staggered animation sequence
    _scaleController.forward().then((_) {
      _checkController.forward().then((_) {
        _fadeController.forward();
      });
    });

    // Auto-navigate to role-wise dashboard after 2 seconds
    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        final isDoctor =
            context.read<AuthViewModel>().currentUser?.isDoctor ?? false;
        final Widget targetDashboard = isDoctor
            ? const DoctorDashboardScreen()
            : const DashboardScreen();

        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => targetDashboard,
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  String get _displayName {
    final user = context.read<AuthViewModel>().currentUser;
    if (user != null && user.fullName.trim().isNotEmpty) {
      return user.fullName.trim();
    }
    if (widget.isEmail) {
      final parts = widget.identifier.split('@');
      return parts[0].isNotEmpty ? _capitalize(parts[0]) : 'User';
    } else {
      return 'User';
    }
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Circle with check mark
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryTeal.withValues(alpha: 0.12),
                      border: Border.all(
                        color: AppColors.primaryTeal,
                        width: 3,
                      ),
                    ),
                    child: ScaleTransition(
                      scale: _checkAnimation,
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.primaryTeal,
                        size: 64,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Welcome Text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Welcome Back,',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.grey[400]
                              : AppColors.textGray,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _displayName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Login Successful! 🎉',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).textTheme.headlineMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        (context.watch<AuthViewModel>().currentUser?.isDoctor ?? false)
                            ? 'Your doctor account is verified.\nTaking you to Doctor Module…'
                            : 'Your identity has been verified.\nTaking you to Patient Module…',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: isDark
                              ? Colors.grey[400]
                              : AppColors.textGray,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Progress bar
                      Column(
                        children: [
                          Text(
                            (context.watch<AuthViewModel>().currentUser?.isDoctor ?? false)
                                ? 'Redirecting to Doctor Module…'
                                : 'Redirecting to Patient Module…',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey[500]
                                  : AppColors.textGray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const LinearProgressIndicator(
                              minHeight: 4,
                              backgroundColor: AppColors.mint,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryTeal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Skip button
                      TextButton(
                        onPressed: () {
                          final isDoctor = context
                                  .read<AuthViewModel>()
                                  .currentUser
                                  ?.isDoctor ??
                              false;
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => isDoctor
                                  ? const DoctorDashboardScreen()
                                  : const DashboardScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          (context.watch<AuthViewModel>().currentUser?.isDoctor ?? false)
                              ? 'Go to Doctor Module →'
                              : 'Go to Patient Module →',
                          style: const TextStyle(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                const MediRxLogo(size: 50, showText: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
