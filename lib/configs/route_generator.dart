import 'package:flutter/material.dart';
import '../features/ai_assistant/presentation/ai_assistant_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/login_success_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/blood_bank/presentation/blood_bank_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/doctor/presentation/doctor_dashboard_screen.dart';
import '../features/doctor/presentation/doctor_home_screen.dart';
import '../features/medication/presentation/medication_screen.dart';
import '../features/menstrual_cycle/presentation/menstrual_cycle_screen.dart';
import '../features/nearest_medical/presentation/nearest_medical_screen.dart';
import '../features/notification/presentation/notification_screen.dart';
import '../features/pediatric_dose/presentation/pediatric_dose_screen.dart';
import '../features/pregnancy/presentation/pregnancy_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/rating/presentation/doctor_rating_screen.dart';
import '../features/scheduling/presentation/scheduling_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/vaccine/presentation/vaccine_screen.dart';

/// Centralized Named Route Generator for MediRx Patient
class RouteGenerator {
  RouteGenerator._();

  // Route Names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String loginSuccess = '/login-success';
  static const String dashboard = '/dashboard';
  static const String doctorDashboard = '/doctor-dashboard';
  static const String doctorHome = '/doctor-home';
  static const String medication = '/medication';
  static const String scheduling = '/scheduling';
  static const String bloodBank = '/blood-bank';
  static const String aiAssistant = '/ai-assistant';
  static const String vaccine = '/vaccine';
  static const String nearestMedical = '/nearest-medical';
  static const String pediatricDose = '/pediatric-dose';
  static const String pregnancy = '/pregnancy';
  static const String menstrualCycle = '/menstrual-cycle';
  static const String profile = '/profile';
  static const String doctorRating = '/doctor-rating';
  static const String settings = '/settings';
  static const String notification = '/notification';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case loginSuccess:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => LoginSuccessScreen(
            identifier: args?['identifier'] ?? '',
            isEmail: args?['isEmail'] ?? true,
          ),
        );
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case doctorDashboard:
        return MaterialPageRoute(builder: (_) => const DoctorDashboardScreen());
      case doctorHome:
        return MaterialPageRoute(builder: (_) => const DoctorHomeScreen());
      case medication:
        return MaterialPageRoute(builder: (_) => const MedicationScreen());
      case scheduling:
        return MaterialPageRoute(builder: (_) => const SchedulingScreen());
      case bloodBank:
        return MaterialPageRoute(builder: (_) => const BloodBankScreen());
      case aiAssistant:
        return MaterialPageRoute(builder: (_) => const AiAssistantScreen());
      case vaccine:
        return MaterialPageRoute(builder: (_) => const VaccineScreen());
      case nearestMedical:
        return MaterialPageRoute(builder: (_) => const NearestMedicalScreen());
      case pediatricDose:
        return MaterialPageRoute(builder: (_) => const PediatricDoseScreen());
      case pregnancy:
        return MaterialPageRoute(builder: (_) => const PregnancyScreen());
      case menstrualCycle:
        return MaterialPageRoute(builder: (_) => const MenstrualCycleScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case doctorRating:
        return MaterialPageRoute(builder: (_) => const DoctorRatingScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}
