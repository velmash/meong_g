import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/features/home/data/repository/location_repository_impl.dart';
import 'package:meong_g/features/home/domain/entity/location_entity.dart';
import 'package:meong_g/features/home/domain/usecase/location_usecase.dart'; // 변경된 UseCase 임포트

// 1. State Class Definition
class HomeState {
  final bool isLoading;
  final LocationEntity? location;
  final String? errorMessage;

  HomeState({this.isLoading = false, this.location, this.errorMessage});

  HomeState copyWith({
    bool? isLoading,
    LocationEntity? location,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      location: location ?? this.location,
      errorMessage: errorMessage, // Allow clearing the error
    );
  }
}

// 2. StateNotifier Definition
class HomeViewModel extends StateNotifier<HomeState> {
  // ViewModel이 UseCase와 Repository의 구현체까지 직접 생성하고 소유
  final LocationUseCase _useCase = LocationUseCase(
    LocationRepositoryImpl(),
  );

  HomeViewModel() : super(HomeState()) {
    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Provider를 통하지 않고 직접 소유한 useCase 인스턴스를 사용
      final location = await _useCase.getCurrentLocation();
      state = state.copyWith(isLoading: false, location: location);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refreshLocation() async {
    await fetchCurrentLocation();
  }
}

// 3. StateNotifierProvider Definition
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((
  ref,
) {
  return HomeViewModel();
});
