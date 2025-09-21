import 'package:flutter/material.dart';
import 'package:grupo_digital_test/presentation/provider/weather_provider.dart';
import 'package:grupo_digital_test/presentation/widgets/forecast_card.dart';
import 'package:provider/provider.dart';

class ForecastView extends StatefulWidget {
  const ForecastView({super.key});

  @override
  State<ForecastView> createState() => _ForecastViewState();
}

class _ForecastViewState extends State<ForecastView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<WeatherProvider>(
        builder: (BuildContext context, WeatherProvider weatherProvider, Widget? child) {
          if (weatherProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (weatherProvider.errorMessage != null) {
            return Center(child: Text(weatherProvider.errorMessage!));
          }
          
          final days = weatherProvider.last5DaysWeather!.days;
          
          if (days == null || days.isEmpty) {
            return const Center(child: Text('No hay datos de pronóstico'));
          }
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Últimos 5 días',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: days.length > 5 ? 5 : days.length,
                    itemBuilder: (context, index) {
                      final day = days[index];
                      return ForecastCard(
                        icon: getWeatherIcon(day.icon),
                        temp: '${day.temp.round()}°',
                        min: '${day.tempmin.round()}°',
                        max: '${day.tempmax.round()}°',
                        precipitation: '${day.precip}mm',
                        day: day.datetime, 
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData getWeatherIcon(String icon) {
    switch (icon.toLowerCase()) {
      case 'clear-day':
      case 'clear':
        return Icons.wb_sunny;
      case 'rain':
        return Icons.grain;
      case 'cloudy':
        return Icons.wb_cloudy;
      case 'partly-cloudy-day':
      case 'partly-cloudy':
        return Icons.cloud;
      default:
        return Icons.wb_sunny;
    }
  }
}
