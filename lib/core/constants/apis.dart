/// MediRx API endpoints and routing configuration
class APIPath {
  APIPath._();

  // Base URLs (can be switched between staging / production)
  static const String baseUrl = 'https://api.medirx.health/api/v1';
  static const String authBaseUrl = '$baseUrl/auth';
  static const String patientBaseUrl = '$baseUrl/patient';
  static const String doctorBaseUrl = '$baseUrl/doctor';

  // Auth Endpoints
  static const String login = '$authBaseUrl/login';
  static const String register = '$authBaseUrl/register';
  static const String refreshToken = '$authBaseUrl/refresh-token';
  static const String forgotPassword = '$authBaseUrl/forgot-password';
  static const String verifyOtp = '$authBaseUrl/verify-otp';
  static const String resetPassword = '$authBaseUrl/reset-password';
  static const String logout = '$authBaseUrl/logout';

  // Patient Endpoints
  static const String patientProfile = '$patientBaseUrl/profile';
  static const String medicalHistory = '$patientBaseUrl/medical-history';
  static const String prescriptions = '$patientBaseUrl/prescriptions';
  static const String appointments = '$patientBaseUrl/appointments';
  static const String notifications = '$patientBaseUrl/notifications';

  // Doctors & Search
  static const String doctorList = '$doctorBaseUrl/list';
  static const String doctorDetails = '$doctorBaseUrl/details';
  static const String doctorRating = '$doctorBaseUrl/rating';

  // Health Services
  static const String bloodBank = '$baseUrl/blood-bank';
  static const String vaccines = '$baseUrl/vaccines';
  static const String nearestMedical = '$baseUrl/nearest-medical';
  static const String aiAssistantChat = '$baseUrl/ai-assistant/chat';
  static const String pregnancyTracker = '$baseUrl/pregnancy';
  static const String menstrualCycle = '$baseUrl/menstrual-cycle';
  static const String pediatricDose = '$baseUrl/pediatric-dose';
}
