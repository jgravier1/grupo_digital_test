import 'package:flutter/material.dart';
import 'package:grupo_digital_test/presentation/widgets/forecast_card.dart';

class ForecastView extends StatefulWidget {
  const ForecastView({super.key});

  @override
  State<ForecastView> createState() => _ForecastViewState();
}

class _ForecastViewState extends State<ForecastView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Últimos 5 días', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ForecastCard(
              icon: Icons.wb_sunny,
              temp: '28°',
              min: '22°',
              max: '30°',
              precipitation: '2mm',
              day: 'Miércoles, 17 Sep',
            ),
            ForecastCard(
              icon: Icons.cloud,
              temp: '25°',
              min: '20°',
              max: '27°',
              precipitation: '0mm',
              day: 'Martes, 16 Sep',
            ),
            ForecastCard(
              icon: Icons.cloud_queue,
              temp: '23°',
              min: '19°',
              max: '25°',
              precipitation: '5mm',
              day: 'Lunes, 15 Sep',
            ),
            ForecastCard(
              icon: Icons.grain,
              temp: '26°',
              min: '21°',
              max: '28°',
              precipitation: '1mm',
              day: 'Domingo, 14 Sep',
            ),
            ForecastCard(
              icon: Icons.wb_cloudy,
              temp: '24°',
              min: '18°',
              max: '26°',
              precipitation: '3mm',
              day: 'Sábado, 13 Sep',
            ),
          ],
        ),
      ),
    );
  }
}
