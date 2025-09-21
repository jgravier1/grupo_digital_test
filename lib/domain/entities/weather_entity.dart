/// Entidad del clima actual
class WeatherEntity {
  final String location;
  final String description;
  final double temperature;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final double humidity;
  final double windSpeed;
  final double windGust;
  final double pressure;
  final double visibility;
  final double uvIndex;
  final double precipProb;
  final DateTime sunrise;
  final DateTime sunset;
  final String condition;
  final String icon;
  final double latitude;
  final double longitude;
  final List<DayEntity>? days;

  const WeatherEntity({
    required this.location,
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.windSpeed,
    required this.windGust,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    required this.precipProb,
    required this.sunrise,
    required this.sunset,
    required this.condition,
    required this.icon,
    required this.latitude,
    required this.longitude,
    this.days
  });
}

class DayEntity {
  final String datetime;
  final double tempmax;
  final double tempmin;
  final double temp;
  final double precip;
  final String conditions;
  final String icon;
  
  DayEntity({
    required this.datetime,
    required this.tempmax,
    required this.tempmin,
    required this.temp,
    required this.precip,
    required this.conditions,
    required this.icon,
  });

  get weatherEvents => null;

  get events => null;

  get days => null;
}
