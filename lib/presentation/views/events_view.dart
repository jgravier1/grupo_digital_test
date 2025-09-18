import 'package:flutter/material.dart';

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
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Baranoa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 4),
                    Text('30°C', style: TextStyle(fontSize: 65)),
                    const SizedBox(height: 2),
                    Text('Nublado', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Min: 24°C', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 20),
                        Text('Max: 32°C', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Indicadores superiores
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
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _IndicatorWidget(title: 'Velocidad de viento', value: '7', subtitle: '', icon: Icons.air),
                    _IndicatorWidget(title: 'Humedad', value: '61%', subtitle: '', icon: Icons.water_drop_outlined),
                    _IndicatorWidget(title: 'Precipitación', value: '4mm', subtitle: '', icon: Icons.cloud_outlined),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Pronóstico próximos días
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
                    const Text('Eventos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 16),
                    ...[
                      _ForecastCard(icon: Icons.cloud, temp: '22°', day: 'Friday, 1 Nov'),
                      _ForecastCard(icon: Icons.cloud_queue, temp: '19°', day: 'Sunday, 3 Nov'),
                      _ForecastCard(icon: Icons.wb_cloudy, temp: '25°', day: 'Saturday, 2 Nov'),
                      _ForecastCard(icon: Icons.cloud_queue, temp: '20°', day: 'Monday, 4 Nov'),
                      _ForecastCard(icon: Icons.cloud_queue, temp: '20°', day: 'Monday, 4 Nov'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
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
        Text(title, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (subtitle.isNotEmpty)
          Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black45)),
      ],
    );
  }
}

class _ForecastCard extends StatelessWidget {
  final IconData icon;
  final String temp;
  final String day;
  const _ForecastCard({
    required this.icon,
    required this.temp,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            radius: 26,
            child: Icon(icon, color: Colors.blueAccent, size: 28),
          ),
          const SizedBox(width: 18),
          Text(temp, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
          const SizedBox(width: 18),
          Expanded(
            child: Text(day, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}
