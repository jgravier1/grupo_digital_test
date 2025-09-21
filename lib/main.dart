import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grupo_digital_test/config/di/locator.dart';
import 'package:grupo_digital_test/config/router/app_router.dart';
import 'package:grupo_digital_test/config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter().appRouter,
      debugShowCheckedModeBanner: false,
      title: 'ClimateMap',
      theme: AppTheme.themeData,
    );
  }
  }
