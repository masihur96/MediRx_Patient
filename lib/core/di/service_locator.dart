import 'package:get_it/get_it.dart';
import '../../configs/network/connectivity_service.dart';
import '../../configs/network/data_provider.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';

// Dashboard
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/presentation/viewmodels/dashboard_viewmodel.dart';

// Medication
import '../../features/medication/data/datasources/medication_remote_datasource.dart';
import '../../features/medication/data/repositories/medication_repository_impl.dart';
import '../../features/medication/domain/repositories/medication_repository.dart';
import '../../features/medication/presentation/viewmodels/medication_viewmodel.dart';

// Vaccine
import '../../features/vaccine/data/datasources/vaccine_remote_datasource.dart';
import '../../features/vaccine/data/repositories/vaccine_repository_impl.dart';
import '../../features/vaccine/domain/repositories/vaccine_repository.dart';
import '../../features/vaccine/presentation/viewmodels/vaccine_viewmodel.dart';

// Pediatric Dose
import '../../features/pediatric_dose/data/datasources/pediatric_dose_remote_datasource.dart';
import '../../features/pediatric_dose/data/repositories/pediatric_dose_repository_impl.dart';
import '../../features/pediatric_dose/domain/repositories/pediatric_dose_repository.dart';
import '../../features/pediatric_dose/presentation/viewmodels/pediatric_dose_viewmodel.dart';

// Notification
import '../../features/notification/data/datasources/notification_remote_datasource.dart';
import '../../features/notification/data/repositories/notification_repository_impl.dart';
import '../../features/notification/domain/repositories/notification_repository.dart';
import '../../features/notification/presentation/viewmodels/notification_viewmodel.dart';

// Hospital / Nearest Medical
import '../../features/nearest_medical/data/datasources/hospital_remote_datasource.dart';
import '../../features/nearest_medical/data/repositories/hospital_repository_impl.dart';
import '../../features/nearest_medical/domain/repositories/hospital_repository.dart';
import '../../features/nearest_medical/presentation/viewmodels/hospital_viewmodel.dart';

// AI Assistant
import '../../features/ai_assistant/data/datasources/ai_assistant_remote_datasource.dart';
import '../../features/ai_assistant/data/repositories/ai_assistant_repository_impl.dart';
import '../../features/ai_assistant/domain/repositories/ai_assistant_repository.dart';
import '../../features/ai_assistant/presentation/viewmodels/ai_assistant_viewmodel.dart';

final GetIt sl = GetIt.instance;

/// Initialize all core dependencies, repositories, usecases, and viewmodels
Future<void> setupServiceLocator() async {
  // ================= Core & Configs =================
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  sl.registerLazySingleton<DataProvider>(() => DataProvider());

  // ================= Feature: Auth =================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DataProvider>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerFactory<AuthViewModel>(
    () => AuthViewModel(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      authRepository: sl<AuthRepository>(),
    ),
  );

  // ================= Feature: Dashboard =================
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(sl<DataProvider>()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl<DashboardRemoteDataSource>()),
  );
  sl.registerFactory<DashboardViewModel>(
    () => DashboardViewModel(sl<DashboardRepository>()),
  );

  // ================= Feature: Medication =================
  sl.registerLazySingleton<MedicationRemoteDataSource>(
    () => MedicationRemoteDataSourceImpl(sl<DataProvider>()),
  );
  sl.registerLazySingleton<MedicationRepository>(
    () => MedicationRepositoryImpl(sl<MedicationRemoteDataSource>()),
  );
  sl.registerFactory<MedicationViewModel>(
    () => MedicationViewModel(sl<MedicationRepository>()),
  );

  // ================= Feature: Vaccine =================
  sl.registerLazySingleton<VaccineRemoteDataSource>(
    () => VaccineRemoteDataSourceImpl(sl<DataProvider>()),
  );
  sl.registerLazySingleton<VaccineRepository>(
    () => VaccineRepositoryImpl(sl<VaccineRemoteDataSource>()),
  );
  sl.registerFactory<VaccineViewModel>(
    () => VaccineViewModel(sl<VaccineRepository>()),
  );

  // ================= Feature: Pediatric Dose =================
  sl.registerLazySingleton<PediatricDoseRemoteDataSource>(
    () => PediatricDoseRemoteDataSourceImpl(sl<DataProvider>()),
  );
  sl.registerLazySingleton<PediatricDoseRepository>(
    () => PediatricDoseRepositoryImpl(sl<PediatricDoseRemoteDataSource>()),
  );
  sl.registerFactory<PediatricDoseViewModel>(
    () => PediatricDoseViewModel(sl<PediatricDoseRepository>()),
  );

  // ================= Feature: Notification =================
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl<DataProvider>()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl<NotificationRemoteDataSource>()),
  );
  sl.registerFactory<NotificationViewModel>(
    () => NotificationViewModel(sl<NotificationRepository>()),
  );

  // ================= Feature: Hospital / Nearest Medical =================
  sl.registerLazySingleton<HospitalRemoteDataSource>(
    () => HospitalRemoteDataSourceImpl(sl<DataProvider>()),
  );
  sl.registerLazySingleton<HospitalRepository>(
    () => HospitalRepositoryImpl(sl<HospitalRemoteDataSource>()),
  );
  sl.registerFactory<HospitalViewModel>(
    () => HospitalViewModel(sl<HospitalRepository>()),
  );

  // ================= Feature: AI Assistant =================
  sl.registerLazySingleton<AiAssistantRemoteDataSource>(
    () => AiAssistantRemoteDataSourceImpl(sl<DataProvider>()),
  );
  sl.registerLazySingleton<AiAssistantRepository>(
    () => AiAssistantRepositoryImpl(sl<AiAssistantRemoteDataSource>()),
  );
  sl.registerFactory<AiAssistantViewModel>(
    () => AiAssistantViewModel(sl<AiAssistantRepository>()),
  );
}
