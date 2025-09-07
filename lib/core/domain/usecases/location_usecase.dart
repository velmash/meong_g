import 'package:meong_g/core/domain/entities/location_entity.dart';
import 'package:meong_g/core/domain/repositories/location_repository.dart';

class LocationUseCase {
  final LocationRepository _repository;

  LocationUseCase(this._repository);

  Future<LocationEntity> getCurrentLocation() {
    return _repository.getCurrentLocation();
  }
}
