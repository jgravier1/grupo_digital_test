import 'package:grupo_digital_test/domain/entities/weather_entity.dart';
import 'package:grupo_digital_test/domain/repositories/weather_repository.dart';

class GetLastFiveDaysUseCase {
  final WeatherRepository repository;
  GetLastFiveDaysUseCase({required this.repository});
  
  Future<WeatherEntity> execute({String? cityName}) {
    return repository.getLastFiveDays(cityName: cityName);
  }
}