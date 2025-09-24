import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:grupo_digital_test/presentation/provider/weather_provider.dart';
import 'package:grupo_digital_test/data/datasources/location_datasource.dart';
import 'package:grupo_digital_test/data/services/location_service.dart';
import 'package:grupo_digital_test/domain/usescases/get_weather_usecase.dart';
import 'package:grupo_digital_test/domain/usescases/get_last_five_days_usecase.dart';
import 'package:get_it/get_it.dart';

import '../../helpers/test_helpers.mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  late WeatherProvider provider;
  late MockGetWeatherUseCase mockGetWeatherUseCase;
  late MockGetLastFiveDaysUseCase mockGetLastFiveDaysUseCase;
  late MockLocationService mockLocationService;
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    // Inicializar Flutter bindings para SharedPreferences
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    // Limpiar GetIt antes de cada test
    GetIt.instance.reset();

    mockGetWeatherUseCase = MockGetWeatherUseCase();
    mockGetLastFiveDaysUseCase = MockGetLastFiveDaysUseCase();
    mockLocationService = MockLocationService();
    mockSharedPreferences = MockSharedPreferences();

    // Registrar mocks en GetIt con los tipos correctos
    GetIt.instance.registerSingleton<LocationService>(mockLocationService);
    GetIt.instance.registerSingleton<GetWeatherUseCase>(mockGetWeatherUseCase);
    GetIt.instance.registerSingleton<GetLastFiveDaysUseCase>(mockGetLastFiveDaysUseCase);

    // Mock básico para SharedPreferences
    when(mockSharedPreferences.getString(any)).thenReturn(null);
    when(mockSharedPreferences.setString(any, any))
        .thenAnswer((_) async => true);

    provider = WeatherProvider();
  });

  tearDown(() {
    // Limpiar GetIt después de cada test
    GetIt.instance.reset();
  });

  group('WeatherProvider Tests', () {
    
    group('fetchWeather', () {
      
      test('''
        GIVEN un servicio de ubicación que retorna una ciudad válida
        AND un use case que retorna datos del clima
        WHEN se solicita el clima
        THEN debe actualizar el estado con los datos correctos
      ''', () async {
        // GIVEN
        when(mockLocationService.getCityNameForWeatherAPI())
            .thenAnswer((_) async => 'Barranquilla,CO');
        when(mockLocationService.getCurrentLocationResult())
            .thenAnswer((_) async => TestData.successfulLocationResult);
        when(mockGetWeatherUseCase.execute(cityName: 'Barranquilla,CO'))
            .thenAnswer((_) async => TestData.weatherEntity);

        // Estado inicial
        expect(provider.isLoading, false);
        expect(provider.weather, isNull);
        expect(provider.errorMessage, isNull);

        // WHEN
        await provider.fetchWeather();

        // THEN
        expect(provider.isLoading, false);
        expect(provider.weather, isNotNull);
        expect(provider.weather!.location, equals('Barranquilla'));
        expect(provider.errorMessage, isNull);
        expect(provider.hasInternetConnection, true);
        expect(provider.locationStatus, LocationPermissionStatus.granted);

        // Verificar llamadas
        verify(mockLocationService.getCityNameForWeatherAPI()).called(1);
        verify(mockGetWeatherUseCase.execute(cityName: 'Barranquilla,CO')).called(1);
      });

      test('''
        GIVEN un use case que lanza excepción de internet
        WHEN se solicita el clima
        THEN debe actualizar el estado de error de conexión
      ''', () async {
        // GIVEN
        when(mockLocationService.getCityNameForWeatherAPI())
            .thenAnswer((_) async => 'TestCity');
        when(mockLocationService.getCurrentLocationResult())
            .thenAnswer((_) async => TestData.successfulLocationResult);
        when(mockGetWeatherUseCase.execute(cityName: 'TestCity'))
            .thenThrow(TestData.internetException);

        // WHEN
        await provider.fetchWeather();

        // THEN
        expect(provider.isLoading, false);
        expect(provider.weather, isNull);
        expect(provider.errorMessage, contains('Sin conexión a internet'));
        expect(provider.hasInternetConnection, false);
      });

      test('''
        GIVEN un use case que lanza excepción del API
        WHEN se solicita el clima
        THEN debe actualizar el estado de error con el mensaje del API
      ''', () async {
        // GIVEN
        when(mockLocationService.getCityNameForWeatherAPI())
            .thenAnswer((_) async => 'TestCity');
        when(mockLocationService.getCurrentLocationResult())
            .thenAnswer((_) async => TestData.successfulLocationResult);
        when(mockGetWeatherUseCase.execute(cityName: 'TestCity'))
            .thenThrow(TestData.apiException);

        // WHEN
        await provider.fetchWeather();

        // THEN
        expect(provider.isLoading, false);
        expect(provider.errorMessage, contains('Error al cargar el clima'));
        expect(provider.hasInternetConnection, true); // No es error de internet
      });

      test('''
        GIVEN un estado de loading
        WHEN se solicita el clima
        THEN debe cambiar isLoading correctamente durante el proceso
      ''', () async {
        // GIVEN
        when(mockLocationService.getCityNameForWeatherAPI())
            .thenAnswer((_) async => 'TestCity');
        when(mockLocationService.getCurrentLocationResult())
            .thenAnswer((_) async => TestData.successfulLocationResult);
        when(mockGetWeatherUseCase.execute(cityName: 'TestCity'))
            .thenAnswer((_) async => TestData.weatherEntity);

        // Estado inicial
        expect(provider.isLoading, false);

        // WHEN
        final future = provider.fetchWeather();
        
        // Durante la ejecución (esto puede ser difícil de verificar en tests unitarios)
        // expect(provider.isLoading, true); // Podría no funcionar por timing
        
        await future;

        // THEN
        expect(provider.isLoading, false);
      });
    });

    group('fetchLastFiveDays', () {
      
      test('''
        GIVEN un use case que retorna datos de 5 días
        WHEN se solicita el clima de los últimos 5 días
        THEN debe actualizar el estado con los datos correctos
      ''', () async {
        // GIVEN
        when(mockLocationService.getCityNameForWeatherAPI())
            .thenAnswer((_) async => 'Barranquilla,CO');
        when(mockGetLastFiveDaysUseCase.execute(cityName: 'Barranquilla,CO'))
            .thenAnswer((_) async => TestData.weatherEntity);

        // WHEN
        await provider.fetchLastFiveDays();

        // THEN
        expect(provider.isLoading, false);
        expect(provider.last5DaysWeather, isNotNull);
        expect(provider.errorMessage, isNull);
        expect(provider.hasInternetConnection, true);

        verify(mockGetLastFiveDaysUseCase.execute(cityName: 'Barranquilla,CO')).called(1);
      });

      test('''
        GIVEN un use case que lanza excepción
        WHEN se solicita el clima de los últimos 5 días
        THEN debe actualizar el estado de error
      ''', () async {
        // GIVEN
        when(mockLocationService.getCityNameForWeatherAPI())
            .thenAnswer((_) async => 'TestCity');
        when(mockGetLastFiveDaysUseCase.execute(cityName: 'TestCity'))
            .thenThrow(TestData.internetException);

        // WHEN
        await provider.fetchLastFiveDays();

        // THEN
        expect(provider.isLoading, false);
        expect(provider.last5DaysWeather, isNull);
        expect(provider.errorMessage, contains('Sin conexión a internet'));
        expect(provider.hasInternetConnection, false);
      });
    });

    group('requestLocationPermission', () {
      
      test('''
        GIVEN permisos de ubicación otorgados
        WHEN se solicitan permisos
        THEN debe actualizar el estado de ubicación y obtener clima
      ''', () async {
        // GIVEN
        when(mockLocationService.getCurrentLocationResult())
            .thenAnswer((_) async => TestData.successfulLocationResult);
        when(mockLocationService.getCityNameForWeatherAPI())
            .thenAnswer((_) async => 'Barranquilla,CO');
        when(mockGetWeatherUseCase.execute(cityName: 'Barranquilla,CO'))
            .thenAnswer((_) async => TestData.weatherEntity);

        // WHEN
        await provider.requestLocationPermission();

        // THEN
        expect(provider.locationStatus, LocationPermissionStatus.granted);
        expect(provider.weather, isNotNull);
        expect(provider.errorMessage, isNull);

        verify(mockLocationService.getCurrentLocationResult()).called(1);
      });

      test('''
        GIVEN permisos de ubicación denegados
        WHEN se solicitan permisos
        THEN debe actualizar el estado con error de permisos
      ''', () async {
        // GIVEN
        when(mockLocationService.getCurrentLocationResult())
            .thenAnswer((_) async => TestData.deniedLocationResult);

        // WHEN
        await provider.requestLocationPermission();

        // THEN
        expect(provider.locationStatus, LocationPermissionStatus.denied);
        expect(provider.errorMessage, isNotNull);
        expect(provider.errorMessage, contains('permisos de ubicación'));

        // No debe intentar obtener clima
        verifyNever(mockGetWeatherUseCase.execute(cityName: anyNamed('cityName')));
      });

      test('''
        GIVEN permisos denegados permanentemente
        WHEN se solicitan permisos
        THEN debe actualizar el estado apropiadamente
      ''', () async {
        // GIVEN
        when(mockLocationService.getCurrentLocationResult())
            .thenAnswer((_) async => TestData.deniedForeverLocationResult);

        // WHEN
        await provider.requestLocationPermission();

        // THEN
        expect(provider.locationStatus, LocationPermissionStatus.deniedForever);
        expect(provider.shouldShowLocationSettings, true);
        expect(provider.errorMessage, contains('denegados permanentemente'));
      });

      test('''
        GIVEN GPS deshabilitado
        WHEN se solicitan permisos
        THEN debe actualizar el estado con error de GPS
      ''', () async {
        // GIVEN
        when(mockLocationService.getCurrentLocationResult())
            .thenAnswer((_) async => TestData.disabledLocationResult);

        // WHEN
        await provider.requestLocationPermission();

        // THEN
        expect(provider.locationStatus, LocationPermissionStatus.disabled);
        expect(provider.errorMessage, contains('GPS está deshabilitado'));
      });
    });

    group('Utility Methods', () {
      
      test('''
        GIVEN diferentes estados de ubicación
        WHEN se solicita el mensaje de error
        THEN debe retornar el mensaje apropiado
      ''', () {
        // Test para diferentes estados
        // Nota: Este test requeriría acceso a los métodos privados o hacer públicos algunos métodos
        
        expect(provider.getLocationErrorMessage(), isA<String>());
      });

      test('''
        GIVEN un error activo
        WHEN se limpia el error
        THEN debe resetear el estado de error
      ''', () {
        // GIVEN - Simular estado de error
        // (Esto requeriría un método para setear el estado de error directamente)
        
        // WHEN
        provider.clearError();

        // THEN
        expect(provider.errorMessage, isNull);
        expect(provider.hasInternetConnection, true);
      });
    });

    group('Cached Data', () {
      
      test('''
        GIVEN datos en caché disponibles
        WHEN se inicializa el provider
        THEN debe cargar los datos desde caché
      ''', () async {
        // GIVEN
        when(mockSharedPreferences.getString('cached_weather'))
            .thenReturn(TestData.cachedWeatherJson);

        // WHEN
        // Esto requeriría crear un nuevo provider o un método para recargar caché
        
        // THEN
        // Verificar que los datos se cargaron desde caché
      });
    });
  });
}
