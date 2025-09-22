# 🌤️ Weather App - Prueba Técnica Grupo Digital

Aplicación Flutter del clima que implementa arquitectura limpia, flavors y sistema completo de tests unitarios.

## 📱 Funcionalidades

- Consulta del clima actual por ubicación GPS
- Historial de últimos 5 días del clima
- Manejo de permisos de ubicación
- Cache local para funcionamiento offline
- Búsqueda por ciudad específica
- Estados de carga y manejo de errores

## 🛠️ Tecnologías

- Flutter 3.0+
- Provider (gestión de estado)
- GoRouter (navegación)
- Dio (HTTP client)
- Mockito (testing)
- GetIt (inyección de dependencias)
- Clean Architecture

## 🚀 Instalación

```bash
# Clonar repositorio
git clone <repository-url>
cd grupo_digital_test

# Instalar dependencias
flutter pub get

# Configurar variables de entorno
mkdir -p assets/env
echo "API_BASE_URL=https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/
API_KEY=TU_API_KEY_AQUI
APP_NAME=Weather Dev
ENVIRONMENT=development" > assets/env/.env.dev

# Ejecutar app (Development)
flutter run --flavor development -t lib/main_dev.dart

# Ejecutar app (Production)
flutter run --flavor production -t lib/main_prod.dart
```

## 📋 Características Implementadas

✅ **Arquitectura limpia** - Separación por capas (Data, Domain, Presentation)  
✅ **Flavors** - Development y Production configurados  
✅ **Tests unitarios** - 31 tests exitosos con Mockito  
✅ **Gestión de estado** - Provider pattern  
✅ **Consumo de API** - Visual Crossing Weather API  
✅ **Manejo de ubicación** - GPS y permisos  
✅ **Cache local** - SharedPreferences para offline  
✅ **Navegación** - GoRouter  
✅ **UI responsive** - Material Design 3  
✅ **Manejo de errores** - Estados de carga, error y éxito  

## 📂 Estructura

```
lib/
├── data/           # Modelos, datasources y repositorios
├── domain/         # Entidades y casos de uso  
├── presentation/   # UI, providers y widgets
├── config/         # DI, routing y theme
├── main_dev.dart   # Entry point desarrollo
└── main_prod.dart  # Entry point producción
```

## 🧪 Tests (31 tests ✅)

```bash
# Ejecutar todos los tests
flutter test test/data/repositories/ test/domain/usecases/ test/data/datasources/weather_datasource_simple_test.dart test/presentation/providers/weather_provider_simple_test.dart

# Resultado: 31 tests exitosos
```

**Cobertura por capa:**
- WeatherDataSource: 8 tests
- WeatherRepository: 6 tests  
- GetWeatherUseCase: 4 tests
- WeatherProvider: 13 tests

## 🎯 Flavors

### Development
```bash
flutter run --flavor development -t lib/main_dev.dart
```
- Título: "Weather Dev"
- Debug banner visible
- Variables: `.env.dev`

### Production
```bash
flutter run --flavor production -t lib/main_prod.dart
```
- Título: "Weather"
- Debug banner oculto
- Variables: `.env.production`

## 🌐 API

Utiliza **Visual Crossing Weather API** para obtener datos del clima en tiempo real.

**Endpoints:**
- Clima actual: `GET /{location}?unitGroup=metric&lang=es&key={API_KEY}`
- Últimos 5 días: `GET /last5days/{location}?unitGroup=metric&lang=es&key={API_KEY}`

## 🔧 Comandos

```bash
# Desarrollo
flutter run --flavor development -t lib/main_dev.dart

# Producción  
flutter run --flavor production -t lib/main_prod.dart

# Tests
flutter test

# Build
flutter build apk --flavor production

# Generar mocks
dart run build_runner build
```

## 📦 Dependencias Principales

```yaml
dependencies:
  provider: ^6.1.5+1
  go_router: ^16.2.1
  dio: ^5.5.0
  geolocator: ^13.0.1
  shared_preferences: ^2.5.3
  get_it: ^8.0.2
  flutter_dotenv: ^6.0.0

dev_dependencies:
  mockito: ^5.4.4
  build_runner: ^2.4.13
```

👨‍💻 **Desarrollador**  
Juan Camilo Gravier Ortega  
Prueba técnica para Grupo Digital - 2025

💡 **Aplicación desarrollada siguiendo buenas prácticas de Flutter y Clean Architecture**