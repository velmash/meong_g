import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/domain/entities/location_entity.dart';
import 'package:meong_g/App/providers.dart';

final homeViewModelProvider = AutoDisposeAsyncNotifierProvider<HomeViewModel, LocationEntity>(
  HomeViewModel.new,
);

class HomeViewModel extends AutoDisposeAsyncNotifier<LocationEntity> {
  @override
  FutureOr<LocationEntity> build() {
    return _fetchCurrentLocation();
  }

  Future<LocationEntity> _fetchCurrentLocation() {
    final useCase = ref.read(getCurrentLocationUseCaseProvider);
    return useCase();
  }

  Future<void> refreshLocation() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCurrentLocation());
  }
}
