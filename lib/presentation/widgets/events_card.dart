
import 'package:flutter/material.dart';

class EventsCard extends StatelessWidget {
  final IconData icon;
  final String type;
  final String datetime;
  final String desc;
  final double? size;
  final bool isFavorite;
  final VoidCallback onAction;
  final bool showAddButton;

  const EventsCard({
    super.key,
    required this.icon,
    required this.type,
    required this.datetime,
    required this.desc,
    this.size,
    required this.isFavorite,
    required this.onAction,
    this.showAddButton = true,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(datetime, style: const TextStyle(fontSize: 14, color: Colors.black45)),
                if (desc.isNotEmpty)
                  Text(desc, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                if (size != null)
                  Text('Tamaño: $size in', style: const TextStyle(fontSize: 14, color: Colors.indigo)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              showAddButton
                  ? (isFavorite ? Icons.check_circle : Icons.add_circle_outline)
                  : Icons.delete_outline,
              color: showAddButton
                  ? (isFavorite ? Colors.blueAccent : Colors.blueAccent)
                  : Colors.red,
            ),
            tooltip: showAddButton ? (isFavorite ? 'Agregado' : 'Agregar a favoritos') : 'Eliminar de favoritos',
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}