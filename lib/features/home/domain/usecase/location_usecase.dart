import 'package:meong_g/features/home/domain/entity/location_entity.dart';
import 'package:meong_g/features/home/domain/repository/location_repository.dart';

class LocationUseCase {
  final LocationRepository _repository;

  LocationUseCase(this._repository);

  Future<LocationEntity> getCurrentLocation() {
    return _repository.getCurrentLocation();
  }
}
