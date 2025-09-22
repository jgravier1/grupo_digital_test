import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:grupo_digital_test/data/datasources/weather_datasource.dart';
import 'package:grupo_digital_test/data/datasources/location_datasource.dart';
import 'package:grupo_digital_test/domain/repositories/weather_repository.dart';
import 'package:grupo_digital_test/domain/usescases/get_weather_usecase.dart';
import 'package:grupo_digital_test/domain/usescases/get_last_five_days_usecase.dart';
import 'package:grupo_digital_test/data/services/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// Generar mocks para todas las dependencias principales
@GenerateMocks([
  WeatherDataSource,
  LocationDataSource,
  WeatherRepository,
  GetWeatherUseCase,
  GetLastFiveDaysUseCase,
  LocationService,
  Dio,
  SharedPreferences,
  InternetConnection,
])
void main() {
  // Este archivo es solo para generar mocks
  // Los mocks se generarán en test_helpers.mocks.dart
}
