
import 'package:flutter/material.dart';

class ForecastCard extends StatelessWidget {
  final IconData icon;
  final String temp;
  final String min;
  final String max;
  final String precipitation;
  final String day;

  const ForecastCard({super.key, 
    required this.icon,
    required this.temp,
    required this.min,
    required this.max,
    required this.precipitation,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(temp, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              Row(
                children: [
                  Text('Min: $min', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(width: 8),
                  Text('Max: $max', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
              Text('Precipitación: $precipitation', style: const TextStyle(fontSize: 14, color: Colors.blueAccent)),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(day, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}