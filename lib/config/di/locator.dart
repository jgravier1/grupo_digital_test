import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grupo_digital_test/data/datasources/location_datasource.dart';
import 'package:grupo_digital_test/data/datasources/location_datasource_impl.dart';
import 'package:grupo_digital_test/data/datasources/weather_datasource.dart';
import 'package:grupo_digital_test/data/datasources/weather_datasource_impl.dart';
import 'package:grupo_digital_test/data/repositories/weather_repository_impl.dart';
import 'package:grupo_digital_test/data/services/location_service.dart';
import 'package:grupo_digital_test/domain/repositories/weather_repository.dart';
import 'package:grupo_digital_test/domain/usescases/get_weather_usecase.dart';
import 'package:grupo_digital_test/domain/usescases/get_last_five_days_usecase.dart';

final GetIt locator = GetIt.instance;

void setupServiceLocator() {
  // External
  locator.registerLazySingleton<Dio>(() => Dio());

  // Data sources
  locator.registerLazySingleton<WeatherDataSource>(
    () => WeatherDataSourceImpl(dio: locator<Dio>()),
  );

  locator.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(),
  );

  // Services
  locator.registerLazySingleton<LocationService>(
    () => LocationService(locator<LocationDataSource>()),
  );

  // Repositories
  locator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(dataSource: locator<WeatherDataSource>()),
  );

  // Use cases
  locator.registerLazySingleton<GetWeatherUseCase>(
    () => GetWeatherUseCase(repository: locator<WeatherRepository>()),
  );
  
  locator.registerLazySingleton<GetLastFiveDaysUseCase>(
    () => GetLastFiveDaysUseCase(repository: locator<WeatherRepository>()),
  );
}