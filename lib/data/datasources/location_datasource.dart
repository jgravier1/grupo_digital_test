/// Estados posibles de los permisos de ubicación
enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  disabled,
}

class LocationResult {
  final double? latitude;
  final double? longitude;
  final String? cityName;
  final LocationPermissionStatus status;
  final String? errorMessage;

  LocationResult({
    this.latitude,
    this.longitude,
    this.cityName,
    required this.status,
    this.errorMessage,
  });

  bool get isSuccess => cityName != null && status == LocationPermissionStatus.granted;
}

abstract interface class LocationDataSource {
  Future<bool> isLocationServiceEnabled();
  
  Future<LocationPermissionStatus> getPermissionStatus();
  
  Future<LocationPermissionStatus> requestPermission();
  
  Future<LocationResult> getCurrentLocationWithCity();
  
  Future<bool> openAppSettings();
}
