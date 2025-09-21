import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:grupo_digital_test/presentation/provider/favorites_provider.dart';
import 'package:grupo_digital_test/presentation/widgets/events_card.dart';
import 'package:grupo_digital_test/data/services/events_service.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        if (favoritesProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (favoritesProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  favoritesProvider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    favoritesProvider.refreshFavorites();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (favoritesProvider.favoriteEvents.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No tienes eventos favoritos',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Agrega eventos desde la sección de eventos',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Eventos Favoritos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${favoritesProvider.favoriteEvents.length} favoritos',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: favoritesProvider.favoriteEvents.length,
                    itemBuilder: (context, index) {
                      final event = favoritesProvider.favoriteEvents[index];
                      return EventsCard(
                        icon: EventsService.getEventIcon(event.type),
                        type: EventsService.getEventTypeDisplayName(event.type),
                        datetime: event.datetime,
                        desc: event.description,
                        isFavorite: true,
                        showAddButton: false,
                        onAction: () {
                          favoritesProvider.removeFromFavorites(event.id);
                        },
                        event: event,
                        onTap: () {
                          context.push('/events-details', extra: event);
                        },
                      );
                    },
                  ),
                ),
                if (favoritesProvider.favoriteEvents.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: TextButton.icon(
                        onPressed: () {
                          _showClearAllDialog(context, favoritesProvider);
                        },
                        icon: const Icon(Icons.clear_all, color: Colors.red),
                        label: const Text(
                          'Limpiar todos los favoritos',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showClearAllDialog(BuildContext context, FavoritesProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpiar favoritos'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar todos los eventos favoritos?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                provider.clearAllFavorites();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Limpiar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}