import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grupo_digital_test/data/datasources/weather_datasource.dart';
import 'package:grupo_digital_test/data/models/weather_response_model.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class WeatherDataSourceImpl implements WeatherDataSource {
  final Dio dio;
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  static const String baseUrl =
      'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/';

  WeatherDataSourceImpl({required this.dio});

  Future<bool> _checkInternetConnection() async {
    final hasConnection = await InternetConnection().hasInternetAccess;
    return hasConnection;
  }

  @override
  Future<WeatherResponseModel> getWeather({String? cityName}) async {
    if (!await _checkInternetConnection()) {
      throw Exception('Sin conexión a internet');
    }

    final city = cityName ?? 'Barranquilla,CO';

    final response = await dio.get(
      '$baseUrl$city?unitGroup=metric&lang=es&key=$apiKey',
    );
    if (response.statusCode == 200 && response.data != null) {
      return WeatherResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } else {
      throw Exception('Error al obtener el clima: ${response.statusCode}');
    }
  }

  @override
  Future<WeatherResponseModel> getLastFiveDays({String? cityName}) async {
    if (!await _checkInternetConnection()) {
      throw Exception('Sin conexión a internet');
    }

    final city = cityName ?? 'Barranquilla,CO';

    final response = await dio.get(
      '$baseUrl$city/last5days?unitGroup=metric&lang=es&key=$apiKey',
    );
    if (response.statusCode == 200 && response.data != null) {
      return WeatherResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } else {
      throw Exception('Error al obtener los últimos 5 días: ${response.statusCode}');
    }
  }


}
