import 'package:flutter/material.dart';
import 'package:grupo_digital_test/presentation/views/forecast_view.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ForecastView());
  }
}