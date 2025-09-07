import 'package:geolocator/geolocator.dart';
import 'package:meong_g/core/domain/entities/location_entity.dart';
import 'package:meong_g/core/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<LocationEntity> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      // Map the Position object from the data source to our pure LocationEntity
      return LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      // Rethrow as a more specific exception or handle as needed
      throw Exception('Failed to get current location: $e');
    }
  }
}
