import 'package:go_router/go_router.dart';
import 'package:grupo_digital_test/presentation/screens/events_screen.dart';
import 'package:grupo_digital_test/presentation/screens/forecast_screen.dart';
import 'package:grupo_digital_test/presentation/screens/home_screen.dart';
import 'package:grupo_digital_test/presentation/screens/map_screen.dart';

class AppRouter {
  final appRouter = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/events',
        builder: (context, state) => const EventsScreen(),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/forecast',
        builder: (context, state) => const ForecastScreen(),
      ),
    ],
  );
}