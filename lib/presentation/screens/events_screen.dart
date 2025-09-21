import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grupo_digital_test/presentation/provider/weather_provider.dart';
import 'package:grupo_digital_test/presentation/views/events_view.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(
      )..fetchWeather() ,
      child: Scaffold(body: EventsView()),
    );
  }
}
