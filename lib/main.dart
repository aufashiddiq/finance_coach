import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'data/services/auth_service.dart';
import 'data/services/database_service.dart';
import 'presentation/providers/app_state_provider.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize services
  final authService = AuthService();
  final databaseService = DatabaseService();
  await authService.initialize();
  await databaseService.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations', // Folder for translation files
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create:
                (_) => AppStateProvider(
                  authService: authService,
                  databaseService: databaseService,
                ),
          ),
        ],
        child: const FinanceCoachApp(),
      ),
    ),
  );
}
