import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'configs/network/connectivity_service.dart';
import 'configs/route_generator.dart';
import 'core/constants/app_constants.dart';
import 'core/di/service_locator.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/ai_assistant/presentation/viewmodels/ai_assistant_viewmodel.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/dashboard/presentation/viewmodels/dashboard_viewmodel.dart';
import 'features/medication/presentation/viewmodels/medication_viewmodel.dart';
import 'features/nearest_medical/presentation/viewmodels/hospital_viewmodel.dart';
import 'features/notification/presentation/viewmodels/notification_viewmodel.dart';
import 'features/pediatric_dose/presentation/viewmodels/pediatric_dose_viewmodel.dart';
import 'features/vaccine/presentation/viewmodels/vaccine_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependency Injection
  await setupServiceLocator();

  // Initialize Network Connectivity Monitoring
  await sl<ConnectivityService>().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => sl<AuthViewModel>()..initAuth()),
        ChangeNotifierProvider(create: (_) => sl<DashboardViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<MedicationViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<VaccineViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<PediatricDoseViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<NotificationViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<HospitalViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<AiAssistantViewModel>()),
      ],
      child: const MediRxApp(),
    ),
  );
}

class MediRxApp extends StatelessWidget {
  const MediRxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('bn', ''),
      ],
      locale: localizationProvider.language == AppLanguage.en
          ? const Locale('en', '')
          : const Locale('bn', ''),
      initialRoute: RouteGenerator.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
