import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:grupo_digital_test/config/di/locator.dart';
import 'package:grupo_digital_test/data/datasources/location_datasource.dart';
import 'package:grupo_digital_test/data/services/location_service.dart';
import 'package:grupo_digital_test/domain/entities/weather_entity.dart';
import 'package:grupo_digital_test/domain/usescases/get_last_five_days_usecase.dart';
import 'package:grupo_digital_test/domain/usescases/get_weather_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherProvider extends ChangeNotifier {
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

  // Estados de ubicación
  LocationPermissionStatus _locationStatus = LocationPermissionStatus.denied;
  LocationPermissionStatus get locationStatus => _locationStatus;

  bool get hasWeatherData => _weather != null;
  bool get hasLastFiveDaysData => _lastFiveDaysWeather != null;
  bool get isLocationGranted => _locationStatus == LocationPermissionStatus.granted;
  
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  late final LocationService _locationService;

  WeatherProvider() {
    _locationService = locator<LocationService>();
    _loadCachedWeatherData();
    _listenToConnectivityChanges();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _saveWeatherData(WeatherEntity weather) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_weather', jsonEncode(weather.toJson()));
      print('Datos guardados en caché exitosamente');
    } catch (e) {
      print('Error guardando datos en caché: $e');
    }
  }

  Future<void> _saveLastFiveDaysData(WeatherEntity lastFiveDaysWeather) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_last_five_days', jsonEncode(lastFiveDaysWeather.toJson()));
      print('Datos de últimos 5 días guardados en caché exitosamente');
    } catch (e) {
      print('Error guardando datos de últimos 5 días en caché: $e');
    }
  }

  Future<void> _loadCachedWeatherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Cargar datos del clima actual
      final cachedWeather = prefs.getString('cached_weather');
      if (cachedWeather != null) {
        final weatherJson = jsonDecode(cachedWeather) as Map<String, dynamic>;
        _weather = WeatherEntity.fromJson(weatherJson);
        print('Datos cargados desde caché: ${_weather?.location}');
      }
      
      // Cargar datos de últimos 5 días
      final cachedLastFiveDays = prefs.getString('cached_last_five_days');
      if (cachedLastFiveDays != null) {
        final lastFiveDaysJson = jsonDecode(cachedLastFiveDays) as Map<String, dynamic>;
        _lastFiveDaysWeather = WeatherEntity.fromJson(lastFiveDaysJson);
      }
      
      notifyListeners();
    } catch (e) {
      print('Error cargando datos en caché: $e');
    }
  }

  Future<void> fetchWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      String cityName = await _locationService.getCityNameForWeatherAPI();
      
      final locationResult = await _locationService.getCurrentLocationResult();
      _locationStatus = locationResult.status;

      final getWeatherUseCase = locator<GetWeatherUseCase>();
      final response = await getWeatherUseCase.execute(cityName: cityName);
      _weather = response;
      _errorMessage = null;
      _hasInternetConnection = true;

      await _saveWeatherData(response);
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
      String cityName = await _locationService.getCityNameForWeatherAPI();

      final getLastFiveDaysUseCase = locator<GetLastFiveDaysUseCase>();
      final response = await getLastFiveDaysUseCase.execute(cityName: cityName);
      _lastFiveDaysWeather = response;
      _errorMessage = null;
      _hasInternetConnection = true;

      await _saveLastFiveDaysData(response);
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

  void clearError() {
    _errorMessage = null;
    _hasInternetConnection = true;
    notifyListeners();
  }

  Future<void> refreshData() async {
    await fetchWeather();
  }

  Future<void> requestLocationPermission() async {
    _isLoading = true;
    notifyListeners();

    try {
      final locationResult = await _locationService.getCurrentLocationResult();
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

  Future<void> openAppSettings() async {
    await _locationService.openAppSettings();
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

  bool get shouldShowLocationSettings => _locationStatus == LocationPermissionStatus.deniedForever;

  void _listenToConnectivityChanges() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _handleConnectivityChange(results);
      },
    );
    
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _handleConnectivityChange(result);
    } catch (e) {
      print('❌ Error verificando conectividad inicial: $e');
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final wasConnected = _hasInternetConnection;
    final isConnected = _isConnectedToInternet(results);
    
    // Solo procesar si el estado cambió
    if (wasConnected != isConnected) {
      _hasInternetConnection = isConnected;
      
      print('🌐 Cambio de conectividad detectado: $isConnected');
      
      if (!isConnected) {
        // Se perdió la conexión
        _errorMessage = 'Sin conexión a internet';
        print('📵 Conexión perdida - mostrando datos del caché');
      } else {
        // Se recuperó la conexión
        _errorMessage = null;
        print('📶 Conexión recuperada');
      }
      
      notifyListeners();
    }
  }

  bool _isConnectedToInternet(List<ConnectivityResult> results) {
    return results.any((result) => 
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.mobile
    );
  }


}