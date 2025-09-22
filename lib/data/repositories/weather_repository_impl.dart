import 'package:grupo_digital_test/data/datasources/weather_datasource.dart';
import 'package:grupo_digital_test/domain/entities/weather_entity.dart';
import 'package:grupo_digital_test/domain/repositories/weather_repository.dart';
import 'package:grupo_digital_test/data/mappers/weather_mapper.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherDataSource dataSource; 
  WeatherRepositoryImpl({required this.dataSource});

  @override
  Future<WeatherEntity> getWeather({String? cityName}) async {
    try {
      final model = await dataSource.getWeather(cityName: cityName);
      return WeatherMapper.toEntity(model);
    } catch (e) {
      throw Exception('Error obteniendo el clima: $e');
    }
  }

 @override
  Future<WeatherEntity> getLastFiveDays({String? cityName}) async {
    try {
      final model = await dataSource.getLastFiveDays(cityName: cityName);
      return WeatherMapper.toEntity(model);
    } catch (e) {
      throw Exception('Error obteniendo los últimos 5 días: $e');
    }
  } 
  

  
}