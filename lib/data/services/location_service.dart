import 'package:grupo_digital_test/data/datasources/location_datasource.dart';

class LocationService {
  final LocationDataSource _locationDataSource;

  LocationService(this._locationDataSource);

  Future<String> getCityNameForWeatherAPI() async {
    try {
      final isEnabled = await _locationDataSource.isLocationServiceEnabled();
      if (!isEnabled) {
        print('GPS deshabilitado, usando ciudad por defecto');
        return 'Barranquilla,CO';
      }

      final permissionStatus = await _locationDataSource.requestPermission();
      
      if (permissionStatus != LocationPermissionStatus.granted) {
        return 'Barranquilla,CO';
      }

      final locationResult = await _locationDataSource.getCurrentLocationWithCity();
      
      if (locationResult.isSuccess && locationResult.cityName != null) {
        print('Ubicación detectada: ${locationResult.cityName}');
        return locationResult.cityName!;
      }
      
      return 'Barranquilla,CO';
    } catch (e) {
      return 'Barranquilla,CO';
    }
  }

  Future<LocationResult> getCurrentLocationResult() async {
    try {
      final isEnabled = await _locationDataSource.isLocationServiceEnabled();
      if (!isEnabled) {
        return LocationResult(
          status: LocationPermissionStatus.disabled,
          errorMessage: 'El GPS está deshabilitado. Por favor habilítalo en Configuración.',
          cityName: 'Barranquilla,CO',
        );
      }

      final permissionStatus = await _locationDataSource.requestPermission();
      
      if (permissionStatus == LocationPermissionStatus.deniedForever) {
        return LocationResult(
          status: LocationPermissionStatus.deniedForever,
          errorMessage: 'Los permisos de ubicación están denegados permanentemente. Ve a Configuración de la app para habilitarlos.',
          cityName: 'Barranquilla,CO',
        );
      }

      if (permissionStatus != LocationPermissionStatus.granted) {
        return LocationResult(
          status: permissionStatus,
          errorMessage: 'Se necesitan permisos de ubicación para mostrar el clima de tu área.',
          cityName: 'Barranquilla,CO',
        );
      }

      return await _locationDataSource.getCurrentLocationWithCity();
    } catch (e) {
      return LocationResult(
        status: LocationPermissionStatus.denied,
        errorMessage: 'Error inesperado al obtener la ubicación: ${e.toString()}',
        cityName: 'Barranquilla,CO',
      );
    }
  }

  Future<bool> openAppSettings() async {
    return await _locationDataSource.openAppSettings();
  }

  Future<bool> isLocationServiceEnabled() async {
    return await _locationDataSource.isLocationServiceEnabled();
  }

  Future<LocationPermissionStatus> getPermissionStatus() async {
    return await _locationDataSource.getPermissionStatus();
  }
}
