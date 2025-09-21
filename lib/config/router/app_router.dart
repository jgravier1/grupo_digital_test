import 'package:go_router/go_router.dart';
import 'package:grupo_digital_test/domain/entities/event_entity.dart';
import 'package:grupo_digital_test/presentation/screens/events_details_screen.dart';
import 'package:grupo_digital_test/presentation/screens/forecast_screen.dart';
import 'package:grupo_digital_test/presentation/screens/map_screen.dart';
import 'package:grupo_digital_test/presentation/screens/base_screen.dart';

class AppRouter {
  final appRouter = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const BaseScreen()),
      GoRoute(
        path: '/forecast',
        builder: (context, state) => const ForecastScreen(),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const MapScreen()),
        GoRoute(
          path: '/events-details',
          builder: (context, state) {
            final event = state.extra as EventEntity?;
            return EventsDetailsScreen(event: event);
          },
        ),
    ],
  );
}
