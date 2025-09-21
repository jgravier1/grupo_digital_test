import 'package:flutter/material.dart';
import 'package:grupo_digital_test/domain/entities/event_entity.dart';
import 'package:grupo_digital_test/data/services/events_service.dart';
import 'package:grupo_digital_test/presentation/provider/favorites_provider.dart';
import 'package:provider/provider.dart';

class EventsDetailsScreen extends StatelessWidget {
  final EventEntity? event;
  
  const EventsDetailsScreen({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    if (event == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalles del Evento'),
        ),
        body: const Center(
          child: Text('No se encontraron detalles del evento'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                EventsService.getEventTypeDisplayName(event!.type),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _getGradientColors(event!.type),
                  ),
                ),
                child: Center(
                  child: Icon(
                    EventsService.getEventIcon(event!.type),
                    size: 80,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información básica del evento
                  _buildInfoCard(
                    title: 'Información del Evento',
                    children: [
                      _buildDetailRow(
                        icon: Icons.event,
                        label: 'Tipo',
                        value: EventsService.getEventTypeDisplayName(event!.type),
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: 'Fecha',
                        value: event!.datetime,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.fingerprint,
                        label: 'ID',
                        value: event!.id,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Descripción
                  _buildInfoCard(
                    title: 'Descripción',
                    children: [
                      Text(
                        event!.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Información adicional
                  _buildInfoCard(
                    title: 'Información Adicional',
                    children: [
                      _buildDetailRow(
                        icon: Icons.warning,
                        label: 'Nivel de Alerta',
                        value: _getAlertLevel(event!.type),
                        color: _getAlertColor(event!.type),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.location_on,
                        label: 'Región Afectada',
                        value: _getRegion(event!.type),
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // Botón de favoritos
                  Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, child) {
                      final isFavorite = favoritesProvider.isFavorite(event!.id);
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            favoritesProvider.toggleFavorite(event!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite 
                                    ? 'Evento removido de favoritos' 
                                    : 'Evento agregado a favoritos',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                          ),
                          label: Text(
                            isFavorite ? 'Quitar de Favoritos' : 'Agregar a Favoritos',
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFavorite ? Colors.red : Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Color> _getGradientColors(String type) {
    switch (type.toLowerCase()) {
      case 'hail':
        return [Colors.blue.shade400, Colors.blue.shade700];
      case 'earthquake':
        return [Colors.brown.shade400, Colors.brown.shade700];
      case 'tornado':
        return [Colors.grey.shade500, Colors.grey.shade800];
      case 'wind':
        return [Colors.cyan.shade400, Colors.cyan.shade700];
      default:
        return [Colors.purple.shade400, Colors.purple.shade700];
    }
  }

  String _getAlertLevel(String type) {
    switch (type.toLowerCase()) {
      case 'hail':
        return 'Moderado';
      case 'earthquake':
        return 'Alto';
      case 'tornado':
        return 'Crítico';
      case 'wind':
        return 'Moderado';
      default:
        return 'Bajo';
    }
  }

  Color _getAlertColor(String type) {
    switch (type.toLowerCase()) {
      case 'hail':
        return Colors.orange;
      case 'earthquake':
        return Colors.red;
      case 'tornado':
        return Colors.red.shade800;
      case 'wind':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String _getRegion(String type) {
    switch (type.toLowerCase()) {
      case 'hail':
        return 'Norte de la Región';
      case 'earthquake':
        return 'Costa Oeste';
      case 'tornado':
        return 'Región Central';
      case 'wind':
        return 'Zona Montañosa';
      default:
        return 'Región General';
    }
  }
}