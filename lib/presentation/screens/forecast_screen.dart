import 'package:flutter/material.dart';
import 'package:grupo_digital_test/presentation/provider/weather_provider.dart';
import 'package:grupo_digital_test/presentation/views/forecast_view.dart';
import 'package:provider/provider.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => WeatherProvider()..fetchLastFiveDays(),
        child: ForecastView(),
      ),
    );
  }
}