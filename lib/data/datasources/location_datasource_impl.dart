import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:grupo_digital_test/data/datasources/location_datasource.dart';

class LocationDataSourceImpl implements LocationDataSource {
  
  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermissionStatus> getPermissionStatus() async {
    final permission = await Geolocator.checkPermission();
    return _mapPermissionToStatus(permission);
  }

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    if (!await isLocationServiceEnabled()) {
      return LocationPermissionStatus.disabled;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return _mapPermissionToStatus(permission);
  }

  @override
  Future<LocationResult> getCurrentLocationWithCity() async {
    try {
      if (!await isLocationServiceEnabled()) {
        return LocationResult(
          status: LocationPermissionStatus.disabled,
          errorMessage: 'El servicio de ubicación está deshabilitado',
        );
      }

      final permissionStatus = await getPermissionStatus();
      if (permissionStatus != LocationPermissionStatus.granted) {
        return LocationResult(
          status: permissionStatus,
          errorMessage: _getPermissionErrorMessage(permissionStatus),
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      String? cityName = await _getCityFromCoordinates(position.latitude, position.longitude);

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: cityName,
        status: LocationPermissionStatus.granted,
      );
    } catch (e) {
      return LocationResult(
        status: LocationPermissionStatus.denied,
        errorMessage: 'Error al obtener la ubicación: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  Future<String?> _getCityFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        
        String? city = placemark.locality ?? 
                      placemark.subAdministrativeArea ?? 
                      placemark.administrativeArea;
                      
        if (city != null) {
          String cleanCity = _cleanCityName(city);
          
          String countryCode = placemark.isoCountryCode ?? 'CO';
          
          return '$cleanCity,$countryCode';
        }
      }
      
      return 'Barranquilla,CO';
    } catch (e) {
      return 'Barranquilla,CO';
    }
  }

  String _cleanCityName(String cityName) {
    String cleaned = cityName.trim();
    
    List<String> words = cleaned.split(' ');
    words = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();
    
    return words.join(' ');
  }

  LocationPermissionStatus _mapPermissionToStatus(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.granted;
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.denied;
    }
  }

  String _getPermissionErrorMessage(LocationPermissionStatus status) {
    switch (status) {
      case LocationPermissionStatus.denied:
        return 'Permisos de ubicación denegados';
      case LocationPermissionStatus.deniedForever:
        return 'Permisos de ubicación denegados permanentemente. Ve a Configuración para habilitarlos.';
      case LocationPermissionStatus.disabled:
        return 'El servicio de ubicación está deshabilitado';
      case LocationPermissionStatus.granted:
        return '';
    }
  }
}
