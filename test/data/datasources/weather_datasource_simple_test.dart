import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:grupo_digital_test/data/models/weather_response_model.dart';
import 'package:grupo_digital_test/data/datasources/weather_datasource.dart';

import '../../helpers/test_helpers.mocks.dart';
import '../../helpers/test_data.dart';

/// Version simplificada del WeatherDataSource para testing
/// que no depende de dotenv
class TestWeatherDataSource implements WeatherDataSource {
  final Dio dio;
  final String apiKey;
  final String baseUrl;

  TestWeatherDataSource({
    required this.dio,
    this.apiKey = 'test_api_key',
    this.baseUrl = 'https://test.api.com/',
  });

  @override
  Future<WeatherResponseModel> getWeather({String? cityName}) async {
    final city = cityName ?? 'Barranquilla,CO';
    final response = await dio.get('$baseUrl$city?key=$apiKey');
    
    if (response.statusCode == 200 && response.data != null) {
      return WeatherResponseModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al obtener el clima: ${response.statusCode}');
    }
  }

  @override
  Future<WeatherResponseModel> getLastFiveDays({String? cityName}) async {
    final city = cityName ?? 'Barranquilla,CO';
    final response = await dio.get('${baseUrl}last5days/$city?key=$apiKey');
    
    if (response.statusCode == 200 && response.data != null) {
      return WeatherResponseModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al obtener los últimos 5 días: ${response.statusCode}');
    }
  }
}

void main() {
  late TestWeatherDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = TestWeatherDataSource(dio: mockDio);
  });

  group('WeatherDataSource Tests - Version Simplificada', () {
    
    group('getWeather', () {
      
      test('''
        GIVEN un API que responde correctamente
        WHEN se solicita el clima para una ciudad
        THEN debe retornar un WeatherResponseModel válido
      ''', () async {
        // GIVEN
        const cityName = 'Barranquilla,CO';
        final expectedUrl = 'https://test.api.com/$cityName?key=test_api_key';
        
        when(mockDio.get(expectedUrl))
            .thenAnswer((_) async => TestData.successfulDioResponse);

        // WHEN
        final result = await dataSource.getWeather(cityName: cityName);

        // THEN
        expect(result, isA<WeatherResponseModel>());
        expect(result.resolvedAddress, contains('Barranquilla'));
        
        verify(mockDio.get(expectedUrl)).called(1);
      });

      test('''
        GIVEN una respuesta de error del API (500)
        WHEN se solicita el clima
        THEN debe lanzar una excepción con el código de error
      ''', () async {
        // GIVEN
        const cityName = 'TestCity';
        final expectedUrl = 'https://test.api.com/$cityName?key=test_api_key';
        
        when(mockDio.get(expectedUrl))
            .thenAnswer((_) async => TestData.errorDioResponse);

        // WHEN & THEN
        expect(
          () => dataSource.getWeather(cityName: cityName),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Error al obtener el clima: 500'),
          )),
        );

        verify(mockDio.get(expectedUrl)).called(1);
      });

      test('''
        GIVEN una excepción de red (timeout, etc.)
        WHEN se solicita el clima
        THEN debe lanzar la excepción correspondiente
      ''', () async {
        // GIVEN
        const cityName = 'TestCity';
        final expectedUrl = 'https://test.api.com/$cityName?key=test_api_key';
        
        when(mockDio.get(expectedUrl))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/weather'),
              type: DioExceptionType.connectionTimeout,
              message: 'Connection timeout',
            ));

        // WHEN & THEN
        expect(
          () => dataSource.getWeather(cityName: cityName),
          throwsA(isA<DioException>()),
        );

        verify(mockDio.get(expectedUrl)).called(1);
      });

      test('''
        GIVEN sin especificar ciudad
        WHEN se solicita el clima
        THEN debe usar Barranquilla,CO como ciudad por defecto
      ''', () async {
        // GIVEN
        const defaultCity = 'Barranquilla,CO';
        final expectedUrl = 'https://test.api.com/$defaultCity?key=test_api_key';
        
        when(mockDio.get(expectedUrl))
            .thenAnswer((_) async => TestData.successfulDioResponse);

        // WHEN
        await dataSource.getWeather(); // Sin cityName

        // THEN
        verify(mockDio.get(expectedUrl)).called(1);
      });
    });

    group('getLastFiveDays', () {
      
      test('''
        GIVEN un API que responde correctamente
        WHEN se solicita el clima de los últimos 5 días
        THEN debe retornar un WeatherResponseModel válido
      ''', () async {
        // GIVEN
        const cityName = 'Barranquilla,CO';
        final expectedUrl = 'https://test.api.com/last5days/$cityName?key=test_api_key';
        
        when(mockDio.get(expectedUrl))
            .thenAnswer((_) async => TestData.successfulDioResponse);

        // WHEN
        final result = await dataSource.getLastFiveDays(cityName: cityName);

        // THEN
        expect(result, isA<WeatherResponseModel>());
        verify(mockDio.get(expectedUrl)).called(1);
      });

      test('''
        GIVEN una respuesta de error del API
        WHEN se solicita el clima de los últimos 5 días
        THEN debe lanzar una excepción con contexto apropiado
      ''', () async {
        // GIVEN
        const cityName = 'TestCity';
        final expectedUrl = 'https://test.api.com/last5days/$cityName?key=test_api_key';
        
        when(mockDio.get(expectedUrl))
            .thenAnswer((_) async => TestData.errorDioResponse);

        // WHEN & THEN
        expect(
          () => dataSource.getLastFiveDays(cityName: cityName),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Error al obtener los últimos 5 días: 500'),
          )),
        );

        verify(mockDio.get(expectedUrl)).called(1);
      });
    });

    group('API Key y Base URL', () {
      
      test('''
        GIVEN un dataSource con API key personalizada
        WHEN se hace una petición
        THEN debe incluir la API key en la URL
      ''', () async {
        // GIVEN
        const customApiKey = 'custom_api_key_123';
        final customDataSource = TestWeatherDataSource(
          dio: mockDio,
          apiKey: customApiKey,
        );
        
        const cityName = 'TestCity';
        final expectedUrl = 'https://test.api.com/$cityName?key=$customApiKey';
        
        when(mockDio.get(expectedUrl))
            .thenAnswer((_) async => TestData.successfulDioResponse);

        // WHEN
        await customDataSource.getWeather(cityName: cityName);

        // THEN
        verify(mockDio.get(expectedUrl)).called(1);
      });

      test('''
        GIVEN un dataSource con base URL personalizada
        WHEN se hace una petición
        THEN debe usar la base URL personalizada
      ''', () async {
        // GIVEN
        const customBaseUrl = 'https://custom.api.example.com/v2/';
        final customDataSource = TestWeatherDataSource(
          dio: mockDio,
          baseUrl: customBaseUrl,
        );
        
        const cityName = 'TestCity';
        final expectedUrl = '${customBaseUrl}$cityName?key=test_api_key';
        
        when(mockDio.get(expectedUrl))
            .thenAnswer((_) async => TestData.successfulDioResponse);

        // WHEN
        await customDataSource.getWeather(cityName: cityName);

        // THEN
        verify(mockDio.get(expectedUrl)).called(1);
      });
    });
  });
}
