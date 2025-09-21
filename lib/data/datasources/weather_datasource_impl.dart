import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grupo_digital_test/data/datasources/weather_datasource.dart';
import 'package:grupo_digital_test/data/models/weather_response_model.dart';

class WeatherDataSourceImpl implements WeatherDataSource {
  final Dio dio;
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  static const String baseUrl =
      'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/';

  WeatherDataSourceImpl({required this.dio});

  @override
  Future<WeatherResponseModel> getWeather() async {
    final response = await dio.get(
      '${baseUrl}Barranquilla,CO?unitGroup=metric&lang=es&key=$apiKey',
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
  Future<WeatherResponseModel> getLastFiveDays() async {
    final response = await dio.get(
      '${baseUrl}Baranoa,CO/last5days?unitGroup=metric&lang=es&key=$apiKey',
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
