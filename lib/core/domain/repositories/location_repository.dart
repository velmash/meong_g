import 'package:meong_g/core/domain/entities/location_entity.dart';

abstract class LocationRepository {
  Future<LocationEntity> getCurrentLocation();
}
