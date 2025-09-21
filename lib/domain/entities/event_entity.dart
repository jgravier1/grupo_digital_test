class EventEntity {
  final String type;
  final String datetime;
  final String description;
  final String id;

  const EventEntity({
    required this.type,
    required this.datetime,
    required this.description,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'datetime': datetime,
      'description': description,
      'id': id,
    };
  }

  factory EventEntity.fromJson(Map<String, dynamic> json) {
    return EventEntity(
      type: json['type'] as String,
      datetime: json['datetime'] as String,
      description: json['description'] as String,
      id: json['id'] as String,
    );
  }

  EventEntity copyWith({
    String? type,
    String? datetime,
    String? description,
    String? id,
  }) {
    return EventEntity(
      type: type ?? this.type,
      datetime: datetime ?? this.datetime,
      description: description ?? this.description,
      id: id ?? this.id,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
