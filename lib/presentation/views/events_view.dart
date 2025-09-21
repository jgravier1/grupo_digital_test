import 'package:flutter/material.dart';
import 'package:grupo_digital_test/presentation/provider/weather_provider.dart';
import 'package:grupo_digital_test/presentation/widgets/events_card.dart';
import 'package:provider/provider.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            if (weatherProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (weatherProvider.errorMessage != null) {
              return Center(child: Text(weatherProvider.errorMessage!));
            } else if (weatherProvider.weather == null) {
              return const Center(child: Text('No weather data available'));
            } else {
              final provider = weatherProvider.weather!;
              return Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            provider.location,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${provider.temperature}°C', style: TextStyle(fontSize: 65)),
                          const SizedBox(height: 2),
                          Text(provider.condition, style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${provider.minTemp}°C', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 20),
                              Text('Max: ${provider.maxTemp}°C', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _IndicatorWidget(
                            title: 'Velocidad de viento',
                            value: '${provider.windSpeed} km/h',
                            subtitle: '',
                            icon: Icons.air,
                          ),
                          _IndicatorWidget(
                            title: 'Humedad',
                            value: '${provider.humidity}%',
                            subtitle: '',
                            icon: Icons.water_drop_outlined,
                          ),
                          _IndicatorWidget(
                            title: 'Precipitación',
                            value: '${provider.precipProb}%',
                            subtitle: '',
                            icon: Icons.cloud_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Events Section
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Eventos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...[
                            EventsCard(
                              icon: Icons.cloud,
                              type: 'Hail',
                              datetime: '1 Nov',
                              desc: '',
                              isFavorite: false,
                              onAction: () {},
                            ),
                            EventsCard(
                              icon: Icons.cloud_queue,
                              type: 'Rain',
                              datetime: '3 Nov',
                              desc: '',
                              isFavorite: false,
                              onAction: () {},
                            ),
                            EventsCard(
                              icon: Icons.wb_cloudy,
                              type: 'Cloudy',
                              datetime: '2 Nov',
                              desc: '',
                              isFavorite: false,
                              onAction: () {},
                            ),
                            EventsCard(
                              icon: Icons.cloud_queue,
                              type: 'Rain',
                              datetime: '4 Nov',
                              desc: '',
                              isFavorite: false,
                              onAction: () {},
                            ),
                            EventsCard(
                              icon: Icons.cloud_queue,
                              type: 'Rain',
                              datetime: '4 Nov',
                              desc: '',
                              size: 20.0,
                              isFavorite: false,
                              onAction: () {},
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class _IndicatorWidget extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  const _IndicatorWidget({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.indigoAccent, size: 28),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.black45),
          ),
      ],
    );
  }
}
