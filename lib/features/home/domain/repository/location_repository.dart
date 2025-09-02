import 'package:meong_g/features/home/domain/entity/location_entity.dart';

abstract class LocationRepository {
  Future<LocationEntity> getCurrentLocation();
}
