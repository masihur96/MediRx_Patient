import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'features/auth/presentation/onboarding_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocalizationProvider(),
      child: const MediRxApp(),
    ),
  );
}

class MediRxApp extends StatelessWidget {
  const MediRxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);

    return MaterialApp(
      title: 'MediRx',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
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
      home: const OnboardingScreen(),
    );
  }
}
