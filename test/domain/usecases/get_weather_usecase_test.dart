import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:grupo_digital_test/domain/usescases/get_weather_usecase.dart';
import 'package:grupo_digital_test/domain/entities/weather_entity.dart';

import '../../helpers/test_helpers.mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  late GetWeatherUseCase useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetWeatherUseCase(repository: mockRepository);
  });

  group('GetWeatherUseCase Tests', () {
    
    test('''
      GIVEN un repository que retorna datos válidos
      WHEN se ejecuta el caso de uso
      THEN debe retornar una WeatherEntity válida
    ''', () async {
      // GIVEN
      const cityName = 'Barranquilla,CO';
      when(mockRepository.getWeather(cityName: cityName))
          .thenAnswer((_) async => TestData.weatherEntity);

      // WHEN
      final result = await useCase.execute(cityName: cityName);

      // THEN
      expect(result, isA<WeatherEntity>());
      expect(result.location, equals('Barranquilla'));
      expect(result.temperature, equals(28.5));
      expect(result.condition, equals('Partly Cloudy'));
      
      // Verificar que se llamó al repository una sola vez
      verify(mockRepository.getWeather(cityName: cityName)).called(1);
    });

      test('''
        GIVEN un repository que lanza una excepción
        WHEN se ejecuta el caso de uso
        THEN debe propagar la excepción
      ''', () async {
        // GIVEN
        const cityName = 'InvalidCity';
        when(mockRepository.getWeather(cityName: cityName))
            .thenThrow(TestData.apiException);

        // WHEN & THEN
        expect(
          () => useCase.execute(cityName: cityName),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Error al obtener el clima: 500'),
          )),
        );

        verify(mockRepository.getWeather(cityName: cityName)).called(1);
      });

    test('''
      GIVEN sin especificar ciudad
      WHEN se ejecuta el caso de uso
      THEN debe pasar null al repository
    ''', () async {
      // GIVEN
      when(mockRepository.getWeather())
          .thenAnswer((_) async => TestData.weatherEntity);

      // WHEN
      final result = await useCase.execute();

      // THEN
      expect(result, isA<WeatherEntity>());
      verify(mockRepository.getWeather()).called(1);
    });

    test('''
      GIVEN múltiples llamadas secuenciales
      WHEN se ejecuta el caso de uso varias veces
      THEN debe hacer las llamadas correspondientes al repository
    ''', () async {
      // GIVEN
      when(mockRepository.getWeather(cityName: anyNamed('cityName')))
          .thenAnswer((_) async => TestData.weatherEntity);

      // WHEN
      await useCase.execute(cityName: 'City1');
      await useCase.execute(cityName: 'City2');
      await useCase.execute(cityName: 'City3');

      // THEN
      verify(mockRepository.getWeather(cityName: 'City1')).called(1);
      verify(mockRepository.getWeather(cityName: 'City2')).called(1);
      verify(mockRepository.getWeather(cityName: 'City3')).called(1);
    });
  });
}
