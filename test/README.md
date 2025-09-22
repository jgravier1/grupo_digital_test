# 🧪 Tests Unitarios - WeatherApp

Este proyecto implementa un conjunto completo de tests unitarios siguiendo la arquitectura limpia y usando Mockito para crear mocks.

## 📁 Estructura de Tests

```
test/
├── data/
│   ├── datasources/
│   │   └── weather_datasource_impl_test.dart
│   └── repositories/
│       └── weather_repository_impl_test.dart
├── domain/
│   └── usecases/
│       └── get_weather_usecase_test.dart
├── presentation/
│   └── providers/
│       └── weather_provider_test.dart
├── helpers/
│   ├── test_helpers.dart               # Configuración de mocks
│   ├── test_helpers.mocks.dart         # Mocks generados automáticamente
│   └── test_data.dart                  # Datos de prueba
├── test_runner.dart                    # Ejecutor principal de tests
└── README.md                           # Esta documentación
```

## 🚀 Cómo Ejecutar Tests

### Ejecutar todos los tests:
```bash
flutter test
```

### Ejecutar tests con coverage:
```bash
flutter test --coverage
```

### Ejecutar tests específicos:
```bash
# Tests de una capa específica
flutter test test/data/
flutter test test/domain/
flutter test test/presentation/

# Test específico
flutter test test/data/datasources/weather_datasource_impl_test.dart
```

### Re-generar mocks:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## 📊 Coverage de Tests

Los tests cubren los siguientes escenarios:

### ✅ WeatherDataSource
- ✅ Respuesta exitosa del API
- ✅ Error de conexión a internet
- ✅ Error del servidor (500, 404, etc.)
- ✅ Timeout de conexión
- ✅ Ciudad por defecto cuando no se especifica
- ✅ Llamadas para últimos 5 días

### ✅ WeatherRepository
- ✅ Transformación de datos exitosa
- ✅ Manejo de errores del datasource
- ✅ Propagación de excepciones con contexto

### ✅ GetWeatherUseCase
- ✅ Ejecución exitosa
- ✅ Propagación de errores
- ✅ Múltiples llamadas secuenciales

### ✅ WeatherProvider
- ✅ Carga exitosa de datos
- ✅ Estados de loading
- ✅ Manejo de errores de internet
- ✅ Manejo de errores del API
- ✅ Permisos de ubicación (otorgados/denegados/permanentes)
- ✅ GPS deshabilitado
- ✅ Caché de datos
- ✅ Notificación de listeners

## 🧩 Patrones de Testing Utilizados

### Given-When-Then
Todos los tests siguen la estructura:
```dart
test('''
  GIVEN [condiciones iniciales]
  WHEN [acción que se ejecuta]  
  THEN [resultado esperado]
''', () async {
  // GIVEN
  // Configuración de mocks y estado inicial
  
  // WHEN  
  // Ejecución de la funcionalidad
  
  // THEN
  // Verificaciones y assertions
});
```

### Mocks con Mockito
```dart
// Configurar comportamiento
when(mockService.method()).thenReturn(value);
when(mockService.method()).thenThrow(exception);

// Verificar llamadas
verify(mockService.method()).called(1);
verifyNever(mockService.method());
```

### Datos de Prueba Centralizados
Todos los datos de prueba están en `test/helpers/test_data.dart`:
- Respuestas del API
- Entidades de dominio
- Excepciones comunes
- Estados de ubicación

## 🔧 Configuración

### Dependencias de Testing
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.13
```

### Generación de Mocks
Los mocks se generan automáticamente usando anotaciones:
```dart
@GenerateMocks([
  WeatherDataSource,
  WeatherRepository,
  // ... más clases
])
```

## 📈 Métricas de Calidad

### Coverage Goal: 90%+
- Data Layer: >95%
- Domain Layer: >98%
- Presentation Layer: >85%

### Criterios de Calidad
- ✅ Todos los paths de éxito cubiertos
- ✅ Todos los paths de error cubiertos
- ✅ Edge cases importantes cubiertos
- ✅ Mocks verificados correctamente
- ✅ Tests independientes entre sí

## 🎯 Escenarios de Testing por Requisito

### ✅ Provider solicita datos al datasource correctamente
- `weather_provider_test.dart` - fetchWeather success case
- Verifica que se llama al use case con parámetros correctos

### ✅ Respuesta exitosa del API
- `weather_datasource_impl_test.dart` - getWeather success case
- Mock de Dio retorna datos válidos

### ✅ Error del API manejado correctamente
- `weather_datasource_impl_test.dart` - error response cases
- `weather_provider_test.dart` - error handling cases

### ✅ Ubicación no disponible/permiso denegado
- `weather_provider_test.dart` - requestLocationPermission cases
- Diferentes estados de LocationPermissionStatus

### ✅ Datos válidos actualizan estado y UI
- `weather_provider_test.dart` - state update verification
- Verifica que notifyListeners() se llama correctamente

## 🚨 Troubleshooting

### Mock no generado
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Test falla por dependencias async
```dart
// Usar pumpAndSettle en widget tests
await tester.pumpAndSettle();

// Usar verifyInOrder para verificar secuencia
verifyInOrder([
  mockService.method1(),
  mockService.method2(),
]);
```

### Problema con SharedPreferences
```dart
// En setUp()
TestWidgetsFlutterBinding.ensureInitialized();
SharedPreferences.setMockInitialValues({});
```

## 📚 Recursos Adicionales

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Clean Architecture Testing Patterns](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
