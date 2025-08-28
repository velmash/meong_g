import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/domain/repositories/location_repository.dart';
import 'package:meong_g/data/repositories/location_repository_impl.dart';
import 'package:meong_g/domain/usecases/get_current_location_usecase.dart';

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl();
});

final getCurrentLocationUseCaseProvider = Provider<GetCurrentLocationUseCase>((ref) {
  final repository = ref.watch(locationRepositoryProvider);
  return GetCurrentLocationUseCase(repository);
});


