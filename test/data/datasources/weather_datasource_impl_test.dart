import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:grupo_digital_test/data/datasources/weather_datasource_impl.dart';
import 'package:grupo_digital_test/data/models/weather_response_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../helpers/test_helpers.mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  late WeatherDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockInternetConnection mockInternetConnection;

  setUpAll(() async {
    // Inicializar dotenv para tests
    dotenv.load(fileName: ".env");
  });

  setUp(() {
    mockDio = MockDio();
    mockInternetConnection = MockInternetConnection();
    dataSource = WeatherDataSourceImpl(dio: mockDio);
  });

  group('WeatherDataSourceImpl Tests', () {
    
    group('getWeather', () {
      
      test('''
        GIVEN una conexión a internet activa y un API que responde correctamente
        WHEN se solicita el clima para una ciudad
        THEN debe retornar un WeatherResponseModel válido
      ''', () async {
        // GIVEN
        const cityName = 'Barranquilla,CO';
        final expectedUrl = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$cityName?unitGroup=metric&lang=es&key=';
        
        // Mock de conexión a internet exitosa
        when(mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => true);

        // Mock de respuesta exitosa del API
        when(mockDio.get(any))
            .thenAnswer((_) async => TestData.successfulDioResponse);

        // WHEN
        final result = await dataSource.getWeather(cityName: cityName);

        // THEN
        expect(result, isA<WeatherResponseModel>());
        expect(result.resolvedAddress, contains('Barranquilla'));
        
        // Verificar que se hizo la llamada correcta
        verify(mockDio.get(expectedUrl)).called(1);
      });

      test('''
        GIVEN sin conexión a internet
        WHEN se solicita el clima
        THEN debe lanzar una excepción de conexión
      ''', () async {
        // GIVEN
        when(mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => false);

        // WHEN & THEN
        expect(
          () => dataSource.getWeather(cityName: 'TestCity'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Sin conexión a internet'),
          )),
        );

        // Verificar que NO se hizo llamada al API
        verifyNever(mockDio.get(any));
      });

      test('''
        GIVEN una respuesta de error del API (500)
        WHEN se solicita el clima
        THEN debe lanzar una excepción con el código de error
      ''', () async {
        // GIVEN
        when(mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => true);

        when(mockDio.get(any))
            .thenAnswer((_) async => TestData.errorDioResponse);

        // WHEN & THEN
        expect(
          () => dataSource.getWeather(cityName: 'TestCity'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Error al obtener el clima: 500'),
          )),
        );
      });

      test('''
        GIVEN una excepción de red (timeout, etc.)
        WHEN se solicita el clima
        THEN debe lanzar la excepción correspondiente
      ''', () async {
        // GIVEN
        when(mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => true);

        when(mockDio.get(any))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/weather'),
              type: DioExceptionType.connectionTimeout,
              message: 'Connection timeout',
            ));

        // WHEN & THEN
        expect(
          () => dataSource.getWeather(cityName: 'TestCity'),
          throwsA(isA<DioException>()),
        );
      });

      test('''
        GIVEN sin especificar ciudad
        WHEN se solicita el clima
        THEN debe usar Barranquilla,CO como ciudad por defecto
      ''', () async {
        // GIVEN
        when(mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => true);
        when(mockDio.get(any))
            .thenAnswer((_) async => TestData.successfulDioResponse);

        // WHEN
        await dataSource.getWeather(); // Sin cityName

        // THEN
        verify(mockDio.get(
          argThat(contains('Barranquilla,CO'))
        )).called(1);
      });
    });

    group('getLastFiveDays', () {
      
      test('''
        GIVEN una conexión a internet activa
        WHEN se solicita el clima de los últimos 5 días
        THEN debe retornar un WeatherResponseModel válido
      ''', () async {
        // GIVEN
        const cityName = 'Barranquilla,CO';
        
        when(mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => true);
        when(mockDio.get(any))
            .thenAnswer((_) async => TestData.successfulDioResponse);

        // WHEN
        final result = await dataSource.getLastFiveDays(cityName: cityName);

        // THEN
        expect(result, isA<WeatherResponseModel>());
        
        // Verificar que se hizo la llamada con la URL correcta (incluyendo last5days)
        verify(mockDio.get(
          argThat(contains('last5days'))
        )).called(1);
      });

      test('''
        GIVEN sin conexión a internet
        WHEN se solicita el clima de los últimos 5 días
        THEN debe lanzar una excepción de conexión
      ''', () async {
        // GIVEN
        when(mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => false);

        // WHEN & THEN
        expect(
          () => dataSource.getLastFiveDays(cityName: 'TestCity'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Sin conexión a internet'),
          )),
        );
      });
    });

    group('_checkInternetConnection', () {
      
      test('''
        GIVEN una conexión a internet activa
        WHEN se verifica la conexión
        THEN debe retornar true
      ''', () async {
        // GIVEN
        when(mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => true);

        // WHEN
        when(mockDio.get(any))
            .thenAnswer((_) async => TestData.successfulDioResponse);
        
        final result = await dataSource.getWeather();

        // THEN
        expect(result, isA<WeatherResponseModel>());
      });

      test('''
        GIVEN sin conexión a internet
        WHEN se verifica la conexión
        THEN debe retornar false y lanzar excepción
      ''', () async {
        // GIVEN
        when(mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => false);

        // WHEN & THEN
        expect(
          () => dataSource.getWeather(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
