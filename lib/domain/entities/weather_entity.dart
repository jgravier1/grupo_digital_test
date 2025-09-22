class WeatherEntity {
  final String location;
  final String address;
  final double temperature;
  final String condition;
  final double humidity;
  final double windSpeed;
  final double precipProb;
  final List<DayEntity>? days;
  final String description;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final double windGust;
  final double pressure;
  final double visibility;
  final double uvIndex;
  final DateTime sunrise;
  final DateTime sunset;
  final String icon;
  final double latitude;
  final double longitude;
  

  WeatherEntity({
    required this.location,
    required this.address,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.precipProb,
    this.days,
    required this.description,
    required this.feelsLike,
    required this.minTemp,
    required this.maxTemp,
    required this.windGust,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
    required this.icon,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'address': address,
      'temperature': temperature,
      'condition': condition,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'precipProb': precipProb,
      'description': description,
      'feelsLike': feelsLike,
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'windGust': windGust,
      'pressure': pressure,
      'visibility': visibility,
      'uvIndex': uvIndex,
      'sunrise': sunrise.toIso8601String(), // Convertir DateTime a String
      'sunset': sunset.toIso8601String(),   // Convertir DateTime a String
      'icon': icon,
      'latitude': latitude,
      'longitude': longitude,
      'days': days?.map((day) => day.toJson()).toList(),
    };
  }

  factory WeatherEntity.fromJson(Map<String, dynamic> json) {
    return WeatherEntity(
      location: json['location'] ?? '',
      address: json['address'] ?? '',
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      condition: json['condition'] ?? '',
      humidity: (json['humidity'] ?? 0.0).toDouble(),
      windSpeed: (json['windSpeed'] ?? 0.0).toDouble(),
      precipProb: (json['precipProb'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      feelsLike: (json['feelsLike'] ?? 0.0).toDouble(),
      minTemp: (json['minTemp'] ?? 0.0).toDouble(),
      maxTemp: (json['maxTemp'] ?? 0.0).toDouble(),
      windGust: (json['windGust'] ?? 0.0).toDouble(),
      pressure: (json['pressure'] ?? 0.0).toDouble(),
      visibility: (json['visibility'] ?? 0.0).toDouble(),
      uvIndex: (json['uvIndex'] ?? 0.0).toDouble(),
      sunrise: json['sunrise'] != null
          ? DateTime.parse(json['sunrise'])
          : DateTime.now(), // Convertir String a DateTime
      sunset: json['sunset'] != null
          ? DateTime.parse(json['sunset'])
          : DateTime.now(),  // Convertir String a DateTime
      icon: json['icon'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      days: (json['days'] as List?)?.map((dayJson) =>
          DayEntity.fromJson(dayJson as Map<String, dynamic>)
      ).toList(),
    );
  }
}

class DayEntity {
  final double tempmax;
  final double tempmin;
  final String conditions;
  final DateTime datetime;
  final String icon;
  final double precip;
  final double temp;

  DayEntity({
    required this.tempmax,
    required this.tempmin,
    required this.conditions,
    required this.datetime,
    required this.icon,
    required this.precip,
    required this.temp,
  });

  Map<String, dynamic> toJson() {
    return {
      'tempmax': tempmax,
      'tempmin': tempmin,
      'conditions': conditions,
      'datetime': datetime.toIso8601String(),
      'icon': icon,
      'precip': precip,
      'temp': temp,
    };
  }

  factory DayEntity.fromJson(Map<String, dynamic> json) {
    return DayEntity(
      tempmax: (json['tempmax'] ?? 0.0).toDouble(),
      tempmin: (json['tempmin'] ?? 0.0).toDouble(),
      conditions: json['conditions'] ?? '',
      datetime: json['datetime'] != null
          ? DateTime.parse(json['datetime'])
          : DateTime.now(),
      icon: json['icon'] ?? '',
      precip: (json['precip'] ?? 0.0).toDouble(),
      temp: (json['temp'] ?? 0.0).toDouble(),
    );
  }

  get weatherEvents => null;

  get events => null;

  get days => null;
}
