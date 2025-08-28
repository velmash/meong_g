import 'package:meong_g/domain/entities/location_entity.dart';
import 'package:meong_g/domain/repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository _repository;

  GetCurrentLocationUseCase(this._repository);

  Future<LocationEntity> call() {
    return _repository.getCurrentLocation();
  }
}
