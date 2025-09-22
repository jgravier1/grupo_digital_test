import 'package:grupo_digital_test/data/models/weather_response_model.dart';
import 'package:grupo_digital_test/domain/entities/weather_entity.dart';
import 'package:dio/dio.dart';
import 'package:grupo_digital_test/data/datasources/location_datasource.dart';

/// Datos de prueba para usar en los tests
class TestData {
  
  // JSON response simulado del API
  static Map<String, dynamic> get weatherApiResponse => {
    "latitude": 10.96854,
    "longitude": -74.78132,
    "resolvedAddress": "Barranquilla, Atlántico, Colombia",
    "address": "Barranquilla,CO",
    "timezone": "America/Bogota",
    "tzoffset": -5.0,
    "description": "Partly cloudy skies throughout the day.",
    "days": [
      {
        "datetime": "2025-09-22",
        "tempmax": 32.2,
        "tempmin": 24.8,
        "temp": 28.5,
        "feelslike": 31.2,
        "humidity": 72.5,
        "precip": 0.0,
        "precipprob": 15.0,
        "windspeed": 18.0,
        "windgust": 25.2,
        "pressure": 1013.2,
        "visibility": 24.1,
        "uvindex": 8.0,
        "sunrise": "06:00:00",
        "sunset": "18:00:00",
        "conditions": "Partly Cloudy",
        "description": "Partly cloudy skies with warm temperatures.",
        "icon": "partly-cloudy-day"
      }
    ],
    "currentConditions": {
      "datetime": "12:00:00",
      "temp": 28.5,
      "feelslike": 31.2,
      "humidity": 72.5,
      "precip": 0.0,
      "precipprob": 15.0,
      "windspeed": 18.0,
      "windgust": 25.2,
      "pressure": 1013.2,
      "visibility": 24.1,
      "uvindex": 8.0,
      "conditions": "Partly Cloudy",
      "icon": "partly-cloudy-day"
    }
  };

  // Modelo de respuesta del API
  static WeatherResponseModel get weatherResponseModel => 
    WeatherResponseModel.fromJson(weatherApiResponse);

  // Entidad de dominio
  static WeatherEntity get weatherEntity => WeatherEntity(
    location: "Barranquilla",
    address: "Barranquilla, Atlántico, Colombia",
    temperature: 28.5,
    condition: "Partly Cloudy",
    humidity: 72.5,
    windSpeed: 18.0,
    precipProb: 15.0,
    description: "Partly cloudy skies with warm temperatures.",
    feelsLike: 31.2,
    minTemp: 24.8,
    maxTemp: 32.2,
    windGust: 25.2,
    pressure: 1013.2,
    visibility: 24.1,
    uvIndex: 8.0,
    sunrise: DateTime.parse("2025-09-22T06:00:00"),
    sunset: DateTime.parse("2025-09-22T18:00:00"),
    icon: "partly-cloudy-day",
    latitude: 10.96854,
    longitude: -74.78132,
  );

  // Response exitoso de Dio
  static Response<Map<String, dynamic>> get successfulDioResponse => Response(
    data: weatherApiResponse,
    statusCode: 200,
    requestOptions: RequestOptions(path: '/weather'),
  );

  // Response de error de Dio
  static Response<Map<String, dynamic>> get errorDioResponse => Response(
    data: null,
    statusCode: 500,
    requestOptions: RequestOptions(path: '/weather'),
  );

  // Resultado de ubicación exitoso
  static LocationResult get successfulLocationResult => LocationResult(
    latitude: 10.96854,
    longitude: -74.78132,
    cityName: "Barranquilla,CO",
    status: LocationPermissionStatus.granted,
  );

  // Resultado de ubicación con permiso denegado
  static LocationResult get deniedLocationResult => LocationResult(
    status: LocationPermissionStatus.denied,
    errorMessage: "Se necesitan permisos de ubicación para mostrar el clima de tu área.",
    cityName: "Barranquilla,CO",
  );

  // Resultado de ubicación con permiso denegado permanentemente
  static LocationResult get deniedForeverLocationResult => LocationResult(
    status: LocationPermissionStatus.deniedForever,
    errorMessage: "Los permisos de ubicación están denegados permanentemente.",
    cityName: "Barranquilla,CO",
  );

  // Resultado de ubicación con GPS deshabilitado
  static LocationResult get disabledLocationResult => LocationResult(
    status: LocationPermissionStatus.disabled,
    errorMessage: "El GPS está deshabilitado. Por favor habilítalo en Configuración.",
    cityName: "Barranquilla,CO",
  );

  // Excepciones comunes
  static Exception get internetException => Exception('Sin conexión a internet');
  static Exception get apiException => Exception('Error al obtener el clima: 500');
  static Exception get genericException => Exception('Error inesperado');

  // Datos para caché
  static String get cachedWeatherJson => '''{
    "location": "Barranquilla",
    "address": "Barranquilla, Atlántico, Colombia",
    "temperature": 28.5,
    "condition": "Partly Cloudy",
    "humidity": 72.5,
    "windSpeed": 18.0,
    "precipProb": 15.0,
    "description": "Partly cloudy skies with warm temperatures.",
    "feelsLike": 31.2,
    "minTemp": 24.8,
    "maxTemp": 32.2,
    "windGust": 25.2,
    "pressure": 1013.2,
    "visibility": 24.1,
    "uvIndex": 8.0,
    "sunrise": "2025-09-22T06:00:00.000",
    "sunset": "2025-09-22T18:00:00.000",
    "icon": "partly-cloudy-day",
    "latitude": 10.96854,
    "longitude": -74.78132
  }''';
}
