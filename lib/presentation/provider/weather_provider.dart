import 'package:flutter/material.dart';
import 'package:grupo_digital_test/config/di/locator.dart';
import 'package:grupo_digital_test/domain/entities/weather_entity.dart';
import 'package:grupo_digital_test/domain/usescases/get_last_five_days_usecase.dart';
import 'package:grupo_digital_test/domain/usescases/get_weather_usecase.dart';

class WeatherProvider extends ChangeNotifier {
  // Estado del clima actual
  WeatherEntity? _weather;
  WeatherEntity? get weather => _weather;

  // Estado de los últimos 5 días (separado)
  WeatherEntity? _lastFiveDaysWeather;
  WeatherEntity? get last5DaysWeather => _lastFiveDaysWeather;

  // Estados de carga y error
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final getWeatherUseCase = locator<GetWeatherUseCase>();
      final response = await getWeatherUseCase.execute();
      _weather = response;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar el clima: ${e.toString()}';
      _weather = null;
    }
    _isLoading = false;

    notifyListeners();
  }

  Future<void> fetchLastFiveDays() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final getLastFiveDaysUseCase = locator<GetLastFiveDaysUseCase>();
      final response = await getLastFiveDaysUseCase.execute();
      _lastFiveDaysWeather = response;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar los últimos 5 días: ${e.toString()}';
      _lastFiveDaysWeather = null;
    }
    _isLoading = false;

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}