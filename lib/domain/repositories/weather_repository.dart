import 'package:grupo_digital_test/domain/entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getWeather({String? cityName});
  Future<WeatherEntity> getLastFiveDays({String? cityName});
}