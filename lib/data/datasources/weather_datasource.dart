import 'package:grupo_digital_test/data/models/weather_response_model.dart';

abstract interface class WeatherDataSource {
  Future<WeatherResponseModel> getWeather();
  Future<WeatherResponseModel> getLastFiveDays();
}