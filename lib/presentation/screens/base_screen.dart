import 'package:flutter/material.dart';
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

  final List<Widget> _screens = [
    const EventsScreen(),
    const ForecastScreen(),
    const FavoritesScreen(),
    const MapScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
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
    );
  }
}
