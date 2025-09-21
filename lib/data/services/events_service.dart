import 'package:flutter/material.dart';
import 'package:grupo_digital_test/domain/entities/event_entity.dart';

class EventsService {
  static List<EventEntity> getSampleEvents() {
    return [
      EventEntity(
        id: '1',
        type: 'hail',
        datetime: '1 Nov',
        description: 'Reporte de granizo de 2.5 cm de diámetro',
      ),
      EventEntity(
        id: '2',
        type: 'earthquake',
        datetime: '3 Nov',
        description: 'Terremoto de magnitud 4.2 en California',
      ),
      EventEntity(
        id: '3',
        type: 'tornado',
        datetime: '2 Nov',
        description: 'Tornado EF-2',
      ),
      EventEntity(
        id: '4',
        type: 'wind',
        datetime: '4 Nov',
        description: 'Daños por vientos de 120 km/h',
      ),
    ];
  }

  static IconData getEventIcon(String type) {
    switch (type.toLowerCase()) {
      case 'hail':
        return Icons.grain; // Icono de granizo
      case 'earthquake':
        return Icons.vibration; // Icono de terremoto
      case 'tornado':
        return Icons.cyclone; // Icono de tornado
      case 'wind':
        return Icons.air; // Icono de viento
      default:
        return Icons.warning; // Icono de advertencia por defecto
    }
  }

  static String getEventTypeDisplayName(String type) {
    switch (type.toLowerCase()) {
      case 'hail':
        return 'Granizo';
      case 'earthquake':
        return 'Terremoto';
      case 'tornado':
        return 'Tornado';
      case 'wind':
        return 'Viento';
      default:
        return 'Evento Climático';
    }
  }
}
