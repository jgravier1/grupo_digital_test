import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grupo_digital_test/config/di/locator.dart';
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

  bool get hasWeatherData => _weather != null;
  bool get hasLastFiveDaysData => _lastFiveDaysWeather != null;

  WeatherProvider() {
    _loadCachedWeatherData();
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

  Future<void> _loadCachedWeatherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedWeather = prefs.getString('cached_weather');
      if (cachedWeather != null) {
        final weatherJson = jsonDecode(cachedWeather) as Map<String, dynamic>;
        _weather = WeatherEntity.fromJson(weatherJson);
        print('Datos cargados desde caché: ${_weather?.location}');
        notifyListeners();
      }
    } catch (e) {
      print('Error cargando datos en caché: $e');
    }
  }

  Future<void> fetchWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      final getWeatherUseCase = locator<GetWeatherUseCase>();
      final response = await getWeatherUseCase.execute();
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
      final getLastFiveDaysUseCase = locator<GetLastFiveDaysUseCase>();
      final response = await getLastFiveDaysUseCase.execute();
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

  void clearError() {
    _errorMessage = null;
    _hasInternetConnection = true;
    notifyListeners();
  }

  Future<void> refreshData() async {
    await fetchWeather();
  }
}