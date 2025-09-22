import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grupo_digital_test/presentation/provider/weather_provider.dart';
import 'package:grupo_digital_test/presentation/provider/favorites_provider.dart';
import 'events_screen.dart';
import 'forecast_screen.dart';
import 'favorites_screen.dart';
import 'map_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  late WeatherProvider _weatherProvider;
  late FavoritesProvider _favoritesProvider;

  @override
  void initState() {
    super.initState();
    _weatherProvider = WeatherProvider();
    _favoritesProvider = FavoritesProvider();
    
    // Cargar datos iniciales
    _weatherProvider.fetchWeather();
    _weatherProvider.fetchLastFiveDays();
  }

  @override
  void dispose() {
    _weatherProvider.dispose();
    _favoritesProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherProvider>.value(value: _weatherProvider),
        ChangeNotifierProvider<FavoritesProvider>.value(value: _favoritesProvider),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            EventsScreen(),
            ForecastScreen(),
            FavoritesScreen(),
            MapScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.event),
              label: 'Eventos',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today),
              label: 'Pronóstico',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
            NavigationDestination(
              icon: Icon(Icons.map),
              label: 'Mapa',
            ),
          ],
        ),
      ),
    );
  }
}
