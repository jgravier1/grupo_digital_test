import 'package:grupo_digital_test/data/models/weather_response_model.dart';
import 'package:grupo_digital_test/domain/entities/weather_entity.dart';

class WeatherMapper {
  static WeatherEntity toEntity(WeatherResponseModel model) {
    final current = model.currentConditions;

    List<DayEntity>? days;
    if (model.days.isNotEmpty) {
      days = model.days.map((day) => DayEntity(
        datetime: _parseDateTime(day.datetime),
        tempmax: day.tempmax ?? 0.0,
        tempmin: day.tempmin ?? 0.0,
        temp: day.temp ?? 0.0,
        precip: day.precip ?? 0.0,
        conditions: _getConditionString(day.conditions),
        icon: _getIconString(day.icon),
      )).toList();
    }

    return WeatherEntity(
      
      location: model.resolvedAddress,
      address: model.address,
      description: model.description,
      temperature: current.temp ?? 0.0,
      feelsLike: current.feelslike ?? 0.0,
      minTemp: current.tempmin ?? current.temp ?? 0.0,
      maxTemp: current.tempmax ?? current.temp ?? 0.0,
      humidity: current.humidity ?? 0.0,
      windSpeed: current.windspeed ?? 0.0,
      windGust: current.windgust ?? 0.0,
      pressure: current.pressure ?? 0.0,
      visibility: current.visibility ?? 0.0,
      uvIndex: current.uvindex ?? 0.0,
      precipProb: current.precipprob ?? 0.0,
      sunrise: current.sunriseEpoch != null
          ? DateTime.fromMillisecondsSinceEpoch(current.sunriseEpoch! * 1000)
          : DateTime.now(),
      sunset: current.sunsetEpoch != null
          ? DateTime.fromMillisecondsSinceEpoch(current.sunsetEpoch! * 1000)
          : DateTime.now(),
      condition: _getConditionString(current.conditions),
      icon: _getIconString(current.icon),
      latitude: model.latitude,
      longitude: model.longitude,
      days: days,
    );
  }


  static DateTime _parseDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return DateTime.now();
    }

    try {
      if (dateTimeString.contains('T')) {
        return DateTime.parse(dateTimeString);
      }

      if (dateTimeString.contains('-') && dateTimeString.length == 10) {
        return DateTime.parse('${dateTimeString}T00:00:00.000Z');
      }

      return DateTime.parse(dateTimeString);
    } catch (e) {
      print('Error parseando datetime: $dateTimeString - $e');
      return DateTime.now();
    }
  }

  static String _getConditionString(Conditions? condition) {
    if (condition == null) return 'Desconocido';
    
    switch (condition) {
      case Conditions.CLEAR:
        return 'Despejado';
      case Conditions.OVERCAST:
        return 'Nublado';
      case Conditions.PARTIALLY_CLOUDY:
        return 'Parcialmente nublado';
      }
  }

  static String _getIconString(Icon? icon) {
    if (icon == null) return 'clear-day';
    
    switch (icon) {
      case Icon.CLEAR_DAY:
        return 'clear-day';
      case Icon.CLEAR_NIGHT:
        return 'clear-night';
      case Icon.CLOUDY:
        return 'cloudy';
      case Icon.PARTLY_CLOUDY_DAY:
        return 'partly-cloudy-day';
      case Icon.PARTLY_CLOUDY_NIGHT:
        return 'partly-cloudy-night';
      }
  }
}