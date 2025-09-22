import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:grupo_digital_test/data/repositories/weather_repository_impl.dart';
import 'package:grupo_digital_test/domain/entities/weather_entity.dart';

import '../../helpers/test_helpers.mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockWeatherDataSource();
    repository = WeatherRepositoryImpl(dataSource: mockDataSource);
  });

  group('WeatherRepositoryImpl Tests', () {
    
    group('getWeather', () {
      
      test('''
        GIVEN un datasource que retorna datos válidos
        WHEN se solicita el clima
        THEN debe retornar una WeatherEntity válida
      ''', () async {
        // GIVEN
        const cityName = 'Barranquilla,CO';
        when(mockDataSource.getWeather(cityName: cityName))
            .thenAnswer((_) async => TestData.weatherResponseModel);

        // WHEN
        final result = await repository.getWeather(cityName: cityName);

        // THEN
        expect(result, isA<WeatherEntity>());
        expect(result.location, isNotEmpty);
        expect(result.temperature, greaterThan(0));
        
        // Verificar que se llamó al datasource
        verify(mockDataSource.getWeather(cityName: cityName)).called(1);
      });

      test('''
        GIVEN un datasource que lanza una excepción
        WHEN se solicita el clima
        THEN debe lanzar una excepción con contexto del repository
      ''', () async {
        // GIVEN
        const cityName = 'TestCity';
        when(mockDataSource.getWeather(cityName: cityName))
            .thenThrow(TestData.internetException);

        // WHEN & THEN
        expect(
          () => repository.getWeather(cityName: cityName),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Error obteniendo el clima'),
          )),
        );

        verify(mockDataSource.getWeather(cityName: cityName)).called(1);
      });

      test('''
        GIVEN sin especificar ciudad
        WHEN se solicita el clima
        THEN debe pasar null al datasource
      ''', () async {
        // GIVEN
        when(mockDataSource.getWeather())
            .thenAnswer((_) async => TestData.weatherResponseModel);

        // WHEN
        final result = await repository.getWeather();

        // THEN
        expect(result, isA<WeatherEntity>());
        verify(mockDataSource.getWeather()).called(1);
      });
    });

    group('getLastFiveDays', () {
      
      test('''
        GIVEN un datasource que retorna datos válidos de 5 días
        WHEN se solicita el clima de los últimos 5 días
        THEN debe retornar una WeatherEntity válida
      ''', () async {
        // GIVEN
        const cityName = 'Barranquilla,CO';
        when(mockDataSource.getLastFiveDays(cityName: cityName))
            .thenAnswer((_) async => TestData.weatherResponseModel);

        // WHEN
        final result = await repository.getLastFiveDays(cityName: cityName);

        // THEN
        expect(result, isA<WeatherEntity>());
        expect(result.location, isNotEmpty);
        
        verify(mockDataSource.getLastFiveDays(cityName: cityName)).called(1);
      });

      test('''
        GIVEN un datasource que lanza una excepción
        WHEN se solicita el clima de los últimos 5 días
        THEN debe lanzar una excepción con contexto apropiado
      ''', () async {
        // GIVEN
        const cityName = 'TestCity';
        when(mockDataSource.getLastFiveDays(cityName: cityName))
            .thenThrow(TestData.apiException);

        // WHEN & THEN
        expect(
          () => repository.getLastFiveDays(cityName: cityName),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Error obteniendo los últimos 5 días'),
          )),
        );

        verify(mockDataSource.getLastFiveDays(cityName: cityName)).called(1);
      });
    });

    group('Error Handling', () {
      
      test('''
        GIVEN diferentes tipos de excepciones del datasource
        WHEN se solicita el clima
        THEN debe envolver la excepción con contexto del repository
      ''', () async {
        // GIVEN
        final testCases = [
          TestData.internetException,
          TestData.apiException,
          TestData.genericException,
        ];

        for (final exception in testCases) {
          when(mockDataSource.getWeather(cityName: 'TestCity'))
              .thenThrow(exception);

          // WHEN & THEN
          expect(
            () => repository.getWeather(cityName: 'TestCity'),
            throwsA(isA<Exception>().having(
              (e) => e.toString(),
              'message',
              allOf([
                contains('Error obteniendo el clima'),
                contains(exception.toString()),
              ]),
            )),
          );
        }
      });
    });
  });
}
