import 'package:flutter/material.dart';
import 'package:grupo_digital_test/config/di/locator.dart';
import 'package:grupo_digital_test/config/router/app_router.dart';
import 'package:grupo_digital_test/config/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  final String flavor;

  const MyApp({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    // Inicializar dependencias
    setupServiceLocator();
    
    return MaterialApp.router(
      routerConfig: AppRouter().appRouter,
      title: _getAppTitle(),
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: _shouldShowDebugBanner(),
    );
  }

  String _getAppTitle() {
    switch (flavor) {
      case 'development':
        return 'Weather Dev';
      case 'production':
        return 'Weather';
      default:
        return 'Weather App';
    }
  }

  bool _shouldShowDebugBanner() {
    return flavor == 'development';
  }
}
