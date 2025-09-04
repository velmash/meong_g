import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/features/home/data/repository/location_repository_impl.dart';
import 'package:meong_g/features/home/domain/entity/location_entity.dart';
import 'package:meong_g/features/home/domain/usecase/location_usecase.dart'; // 변경된 UseCase 임포트

// 1. State Class Definition
class HomeState {
  final bool isMapLoading;
  final LocationEntity? location;
  final String? errorMessage;
  final List<String>? petNames;

  HomeState({
    this.isMapLoading = false,
    this.location,
    this.errorMessage,
    this.petNames,
  });

  HomeState copyWith({
    bool? isLoading,
    LocationEntity? location,
    String? errorMessage,
    List<String>? petNames,
  }) {
    return HomeState(
      isMapLoading: isLoading ?? isMapLoading,
      location: location ?? this.location,
      errorMessage: errorMessage, // Allow clearing the error
      petNames: petNames,
    );
  }
}

// 2. StateNotifier Definition
class HomeViewModel extends StateNotifier<HomeState> {
  // ViewModel이 UseCase와 Repository의 구현체까지 직접 생성하고 소유
  final LocationUseCase _useCase = LocationUseCase(LocationRepositoryImpl());

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

  Future<List<String>> fetchPets() async {
    // Simulate fetching pet names from a data source
    await Future.delayed(Duration(seconds: 1));
    final petNames = ['멍쥐'];
    state = state.copyWith(petNames: petNames);
    return petNames;
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
