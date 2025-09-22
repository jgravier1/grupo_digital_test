/// Archivo principal para ejecutar todos los tests
/// Uso: flutter test test/test_runner.dart

import 'package:flutter_test/flutter_test.dart';

// Importar todos los tests
import 'data/datasources/weather_datasource_impl_test.dart' as weather_datasource_tests;
import 'data/repositories/weather_repository_impl_test.dart' as weather_repository_tests;
import 'domain/usecases/get_weather_usecase_test.dart' as get_weather_usecase_tests;
import 'presentation/providers/weather_provider_test.dart' as weather_provider_tests;

void main() {
  group('🧪 Weather App - Tests Unitarios Completos', () {
    
    group('📊 Data Layer Tests', () {
      group('DataSources', () {
        weather_datasource_tests.main();
      });
      
      group('Repositories', () {
        weather_repository_tests.main();
      });
    });

    group('🏗️ Domain Layer Tests', () {
      group('Use Cases', () {
        get_weather_usecase_tests.main();
      });
    });

    group('🎨 Presentation Layer Tests', () {
      group('Providers', () {
        weather_provider_tests.main();
      });
    });
  });
}
