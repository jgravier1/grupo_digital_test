import 'package:flutter/material.dart';
import 'package:grupo_digital_test/config/router/app_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter().appRouter,
      debugShowCheckedModeBanner: false,
      title: 'ClimateMap',
    
    );
  }
}