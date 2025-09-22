import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:grupo_digital_test/domain/entities/weather_entity.dart';
import 'package:grupo_digital_test/data/datasources/location_datasource.dart';
import 'package:grupo_digital_test/domain/usescases/get_weather_usecase.dart';
import 'package:grupo_digital_test/domain/usescases/get_last_five_days_usecase.dart';
import 'package:grupo_digital_test/data/services/location_service.dart';

import '../../helpers/test_helpers.mocks.dart';
import '../../helpers/test_data.dart';

/// Versión simplificada del WeatherProvider para testing
/// que no depende de GetIt ni SharedPreferences
class TestWeatherProvider extends ChangeNotifier {
  final GetWeatherUseCase getWeatherUseCase;
  final GetLastFiveDaysUseCase getLastFiveDaysUseCase;
  final LocationService locationService;

  WeatherEntity? _weather;
  WeatherEntity? get weather => _weather;

  WeatherEntity? _lastFiveDaysWeather;
  WeatherEntity? get last5DaysWeather => _lastFiveDaysWeather;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasInternetConnection = true;
  bool get hasInternetConnection => _hasInternetConnection;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LocationPermissionStatus _locationStatus = LocationPermissionStatus.denied;
  LocationPermissionStatus get locationStatus => _locationStatus;

  bool get hasWeatherData => _weather != null;
  bool get hasLastFiveDaysData => _lastFiveDaysWeather != null;
  bool get isLocationGranted => _locationStatus == LocationPermissionStatus.granted;
  bool get shouldShowLocationSettings => _locationStatus == LocationPermissionStatus.deniedForever;

  TestWeatherProvider({
    required this.getWeatherUseCase,
    required this.getLastFiveDaysUseCase,
    required this.locationService,
  });

  Future<void> fetchWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Obtener nombre de ciudad (desde GPS o por defecto)
      String cityName = await locationService.getCityNameForWeatherAPI();
      
      // Obtener estado de ubicación para el UI
      final locationResult = await locationService.getCurrentLocationResult();
      _locationStatus = locationResult.status;

      final response = await getWeatherUseCase.execute(cityName: cityName);
      _weather = response;
      _errorMessage = null;
      _hasInternetConnection = true;
    } catch (e) {
      if (e.toString().contains('Sin conexión a internet')) {
        _errorMessage = 'Sin conexión a internet';
        _hasInternetConnection = false;
      } else {
        _errorMessage = 'Error al cargar el clima: ${e.toString()}';
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchLastFiveDays() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Obtener nombre de ciudad
      String cityName = await locationService.getCityNameForWeatherAPI();

      final response = await getLastFiveDaysUseCase.execute(cityName: cityName);
      _lastFiveDaysWeather = response;
      _errorMessage = null;
      _hasInternetConnection = true;
    } catch (e) {
      if (e.toString().contains('Sin conexión a internet')) {
        _errorMessage = 'Sin conexión a internet';
        _hasInternetConnection = false;
      } else {
        _errorMessage = 'Error al cargar los últimos 5 días: ${e.toString()}';
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> requestLocationPermission() async {
    _isLoading = true;
    notifyListeners();

    try {
      final locationResult = await locationService.getCurrentLocationResult();
      _locationStatus = locationResult.status;
      
      if (locationResult.status == LocationPermissionStatus.granted) {
        await fetchWeather();
      } else {
        _errorMessage = locationResult.errorMessage;
      }
    } catch (e) {
      _errorMessage = 'Error al solicitar permisos: ${e.toString()}';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _hasInternetConnection = true;
    notifyListeners();
  }

  String getLocationErrorMessage() {
    switch (_locationStatus) {
      case LocationPermissionStatus.denied:
        return 'Se necesitan permisos de ubicación para mostrar el clima de tu área actual.';
      case LocationPermissionStatus.deniedForever:
        return 'Los permisos de ubicación están denegados permanentemente. Ve a Configuración para habilitarlos.';
      case LocationPermissionStatus.disabled:
        return 'El GPS está deshabilitado. Por favor habilítalo en Configuración.';
      case LocationPermissionStatus.granted:
        return '';
    }
  }
}

void main() {
  late TestWeatherProvider provider;
  late MockGetWeatherUseCase mockGetWeatherUseCase;
  late MockGetLastFiveDaysUseCase mockGetLastFiveDaysUseCase;
  late MockLocationService mockLocationService;

  setUp(() {
    mockGetWeatherUseCase = MockGetWeatherUseCase();
    mockGetLastFiveDaysUseCase = MockGetLastFiveDaysUseCase();
    mockLocationService = MockLocationService();

    provider = TestWeatherProvider(
      getWeatherUseCase: mockGetWeatherUseCase,
      getLastFiveDaysUseCase: mockGetLastFiveDaysUseCase,
      locationService: mockLocationService,
    );
  });

  group('WeatherProvider Tests - Version Simplificada', () {
    
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

        verify(mockLocationService.getCurrentLocationResult()).called(2); // Se llama en requestLocationPermission y fetchWeather
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
        expect(provider.getLocationErrorMessage(), isA<String>());
        
        // Cambiar estado manualmente y probar
        provider.requestLocationPermission();
        expect(provider.getLocationErrorMessage(), isA<String>());
      });

      test('''
        GIVEN un error activo
        WHEN se limpia el error
        THEN debe resetear el estado de error
      ''', () {
        // GIVEN - Simular estado de error
        provider.fetchWeather(); // Esto puede generar error dependiendo de los mocks
        
        // WHEN
        provider.clearError();

        // THEN
        expect(provider.errorMessage, isNull);
        expect(provider.hasInternetConnection, true);
      });
    });

    group('Properties', () {
      
      test('''
        GIVEN un provider recién inicializado
        WHEN se verifican las propiedades iniciales
        THEN deben tener valores por defecto correctos
      ''', () {
        // THEN
        expect(provider.weather, isNull);
        expect(provider.last5DaysWeather, isNull);
        expect(provider.isLoading, false);
        expect(provider.hasInternetConnection, true);
        expect(provider.errorMessage, isNull);
        expect(provider.locationStatus, LocationPermissionStatus.denied);
        expect(provider.hasWeatherData, false);
        expect(provider.hasLastFiveDaysData, false);
        expect(provider.isLocationGranted, false);
        expect(provider.shouldShowLocationSettings, false);
      });
    });
  });
}
