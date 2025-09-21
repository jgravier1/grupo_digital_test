import 'package:grupo_digital_test/domain/entities/weather_entity.dart';
import 'package:grupo_digital_test/domain/repositories/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository repository;
  GetWeatherUseCase({required this.repository});
  Future<WeatherEntity> execute() {
    return repository.getWeather();
  }
}