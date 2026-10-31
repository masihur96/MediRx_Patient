/// MediRx API endpoints and routing configuration
class APIPath {
  APIPath._();

  // Base URLs
  static const String baseUrl = 'https://medirx.unipexel.org/api/v1';
  static const String authBaseUrl = '$baseUrl/auth';
  static const String patientBaseUrl = '$baseUrl/patient';
  static const String doctorBaseUrl = '$baseUrl/doctor';

  // User & Profile Endpoints
  static const String user = '$baseUrl/user';
  static const String refreshToken = '$baseUrl/refresh-token';

  // Auth Endpoints
  static const String login = '$authBaseUrl/login';
  static const String register = '$authBaseUrl/register';
  static const String forgotPassword = '$authBaseUrl/password/email';
  static const String verifyOtp = '$authBaseUrl/verify-otp';
  static const String resetPassword = '$authBaseUrl/reset-password';
  static const String logout = '$authBaseUrl/logout';

  // Patient Dashboard & Vitals
  static const String patientDashboardOverview = '$patientBaseUrl/dashboard/overview';
  static String patientVitalsTrends(dynamic id) => '$patientBaseUrl/dashboard/$id/vitals-trends';
  static String patientDayDetails(String date) => '$patientBaseUrl/dashboard/day-details?date=$date';

  // Patient Medications & Schedules
  static const String patientMedications = '$patientBaseUrl/medications';
  static String patientMedicationDetail(dynamic id) => '$patientBaseUrl/medications/$id';
  static String patientMedicationSchedules(dynamic id) => '$patientBaseUrl/medications/$id/schedules';
  static const String patientMedicationsDashboard = '$patientBaseUrl/medications/dashboard';
  static const String patientMedicationLogs = '$patientBaseUrl/medication-logs';
  static String patientMedicationLogTaken(dynamic id) => '$patientBaseUrl/medication-logs/$id/taken';
  static String patientMedicationLogSkip(dynamic id) => '$patientBaseUrl/medication-logs/$id/skip';
  static String patientMedicationLogSnooze(dynamic id) => '$patientBaseUrl/medication-logs/$id/snooze';

  // Prescriptions
  static const String patientPrescriptions = '$patientBaseUrl/prescriptions';
  static String patientPrescriptionDetails(dynamic id) => '$patientBaseUrl/prescriptions/$id';
  static String patientPrescriptionMedications(dynamic id) => '$patientBaseUrl/prescriptions/medications/$id';

  // Vaccines & Vaccinations
  static const String patientVaccines = '$patientBaseUrl/vaccines';
  static const String patientVaccinations = '$patientBaseUrl/vaccinations';
  static String patientVaccinationDetail(dynamic id) => '$patientBaseUrl/vaccinations/$id';
  static const String patientVaccinationSchedules = '$patientBaseUrl/vaccination-schedules';
  static String patientVaccinationScheduleDetail(dynamic id) => '$patientBaseUrl/vaccination-schedules/$id';

  // Pediatric Dose Endpoints
  static const String pediatricDoseMedicines = '$baseUrl/pediatric-dose/medicines';
  static const String pediatricDoseCalculate = '$baseUrl/pediatric-dose/calculate';
  static const String pediatricDoseRecent = '$baseUrl/pediatric-dose/recent';

  // Pregnancy Tracker Endpoints
  static const String pregnancyProfile = '$baseUrl/pregnancy/profile';
  static const String pregnancyStatus = '$baseUrl/pregnancy/status';
  static const String pregnancySymptoms = '$baseUrl/pregnancy/symptoms';

  // Menstrual Cycle Endpoints
  static const String menstrualCycleStatus = '$baseUrl/menstrual-cycle/status';
  static const String menstrualCycleLog = '$baseUrl/menstrual-cycle/log';

  // AI Assistant Endpoints
  static const String aiAssistantChat = '$baseUrl/ai-assistant/chat';

  // Notifications Endpoints
  static const String notifications = '$baseUrl/notifications';
  static String notificationRead(dynamic id) => '$baseUrl/notifications/$id/read';

  // Hospitals & Nearest Medical Endpoints
  static const String hospitals = '$baseUrl/hospitals';
  static const String hospitalTypes = '$baseUrl/hospitals-types';
  static String hospitalDetail(dynamic id) => '$baseUrl/hospitals/$id';

  // Doctors & Specialties
  static const String doctors = '$baseUrl/doctors';
  static String doctorDetail(dynamic id) => '$baseUrl/doctors/$id';
  static const String medicalSpecialties = '$baseUrl/medical-specialties';
  static const String doctorRatings = '$baseUrl/doctor-ratings';

  // Appointments
  static const String appointments = '$baseUrl/appointments';

  // Settings
  static const String settings = '$baseUrl/settings';

  // Legacy mappings for backwards compatibility
  static const String patientProfile = '$patientBaseUrl/profile';
  static const String medicalHistory = '$patientBaseUrl/medical-history';
  static const String prescriptions = patientPrescriptions;
  static const String doctorList = doctors;
  static const String doctorDetails = doctors;
  static const String doctorRating = doctorRatings;
  static const String bloodBank = '$baseUrl/blood-bank';
  static const String vaccines = patientVaccines;
  static const String nearestMedical = hospitals;
  static const String pregnancyTracker = pregnancyStatus;
  static const String menstrualCycle = menstrualCycleStatus;
  static const String pediatricDose = pediatricDoseMedicines;
}
