import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/app_state_provider.dart';
import 'routes.dart';
import 'theme.dart';

class FinanceCoachApp extends StatelessWidget {
  const FinanceCoachApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    return Consumer<AppStateProvider>(
      builder: (context, appStateProvider, _) {
        return MaterialApp(
          localizationsDelegates: buildContext.localizationDelegates,
          supportedLocales: buildContext.supportedLocales,
          locale: buildContext.locale,
          title: 'Personal Finance Coach',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appStateProvider.themeMode,
          initialRoute:
              appStateProvider.isUserLoggedIn
                  ? AppRoutes.dashboard
                  : AppRoutes.onboarding,
          onGenerateRoute: AppRouter.onGenerateRoute,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
