import 'package:flutter/material.dart';

class Event {
  final String type;
  final String datetime;
  final String desc;
  final double? size;
  final IconData icon;

  Event({
    required this.type,
    required this.datetime,
    required this.desc,
    this.size,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'datetime': datetime,
    'desc': desc,
    'size': size,
    'icon': icon.codePoint,
  };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    type: json['type'],
    datetime: json['datetime'],
    desc: json['desc'],
    size: json['size'] != null ? (json['size'] as num).toDouble() : null,
    icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
  );
}
