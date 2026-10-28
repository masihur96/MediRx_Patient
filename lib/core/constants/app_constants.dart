/// Core application constants for MediRx Patient
class AppConstants {
  AppConstants._();

  // Application Info
  static const String appName = 'MediRx';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Your personal healthcare companion';

  // Storage Keys
  static const String tokenKey = 'medirx_auth_token';
  static const String refreshTokenKey = 'medirx_refresh_token';
  static const String userKey = 'medirx_user_data';
  static const String isFirstRunKey = 'medirx_is_first_run';
  static const String languageKey = 'medirx_language';
  static const String themeModeKey = 'medirx_theme_mode';

  // User Roles
  static const String rolePatient = 'PATIENT';
  static const String roleDoctor = 'DOCTOR';
  static const String roleAdmin = 'ADMIN';

  // Appointment Statuses
  static const String appointmentScheduled = 'SCHEDULED';
  static const String appointmentCompleted = 'COMPLETED';
  static const String appointmentCancelled = 'CANCELLED';

  // Default Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your internet connection.';
  static const String errorUnauthorized = 'Session expired. Please log in again.';
  static const String errorTimeout = 'Connection timed out. Please try again.';
}
