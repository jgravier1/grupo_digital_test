import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grupo_digital_test/presentation/provider/weather_provider.dart';
import 'package:grupo_digital_test/presentation/widgets/forecast_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
        builder: (
          BuildContext context,
          WeatherProvider weatherProvider,
          Widget? child,
        ) {
          // Mostrar toast si hay error de conexión pero tenemos datos guardados
          if (weatherProvider.errorMessage != null &&
              !weatherProvider.hasInternetConnection &&
              weatherProvider.hasLastFiveDaysData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Fluttertoast.showToast(
                  msg: "Sin conexión a internet",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.orange,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            });
          }

          if (weatherProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando pronóstico...'),
                ],
              ),
            );
          }

          if (weatherProvider.errorMessage != null &&
              weatherProvider.last5DaysWeather == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    weatherProvider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => weatherProvider.fetchLastFiveDays(),
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final days = weatherProvider.last5DaysWeather?.days;

          if (days == null || days.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_queue, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No hay datos de pronóstico disponibles'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => weatherProvider.fetchLastFiveDays(),
                    child: Text('Cargar Pronóstico'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Banner de sin conexión a internet
              if (weatherProvider.errorMessage != null && !weatherProvider.hasInternetConnection)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.orange.withOpacity(0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Sin conexión a internet, mostrando datos guardados',
                          style: TextStyle(color: Colors.orange[800], fontSize: 14),
                        ),
                      ),
                      IconButton(
                        onPressed: () => weatherProvider.fetchLastFiveDays(),
                        icon: const Icon(Icons.refresh, color: Colors.orange, size: 20),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Últimos 5 días',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                              day: _formatDate(day.datetime),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Formatea la fecha para mostrar solo día, mes y año limpio
  String _formatDate(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
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
