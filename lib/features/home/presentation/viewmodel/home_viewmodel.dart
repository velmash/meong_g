import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/features/home/data/repository/location_repository_impl.dart';
import 'package:meong_g/features/home/data/repository/meong_g_repository_impl.dart';
import 'package:meong_g/features/home/domain/entity/location_entity.dart';
import 'package:meong_g/features/home/domain/entity/meong_g.dart';
import 'package:meong_g/features/home/domain/usecase/location_usecase.dart';
import 'package:meong_g/features/home/domain/usecase/meong_g_usecase.dart';
import 'package:meong_g/features/my_page/data/repository/kakao_auth_repository_impl.dart';
import 'package:meong_g/features/my_page/domain/usecase/kakao_login_usecase.dart'; // 변경된 UseCase 임포트

// 1. State Class Definition
class HomeState {
  final bool isMapLoading;
  final LocationEntity? location;
  final String? errorMessage;
  final List<MeongG>? meongGs;

  HomeState({this.isMapLoading = false, this.location, this.errorMessage, this.meongGs});

  HomeState copyWith({bool? isLoading, LocationEntity? location, String? errorMessage, List<MeongG>? meongGs}) {
    return HomeState(
      isMapLoading: isLoading ?? isMapLoading,
      location: location ?? this.location,
      errorMessage: errorMessage, // Allow clearing the error
      meongGs: meongGs,
    );
  }
}

// 2. StateNotifier Definition
class HomeViewModel extends StateNotifier<HomeState> {
  // ViewModel이 UseCase와 Repository의 구현체까지 직접 생성하고 소유
  final LocationUseCase _useCase = LocationUseCase(LocationRepositoryImpl());
  final MeongGUseCase _meongGUseCase = MeongGUseCase(MeongGRepositoryImpl());
  final KakaoLoginUsecase _kakaoLoginUsecase = KakaoLoginUsecase(KakaoAuthRepositoryImpl());

  HomeViewModel() : super(HomeState()) {
    fetchCurrentLocation();
    fetchPets();
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

  Future<List<MeongG>> fetchPets() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final meongGs = await _meongGUseCase.getMeongGs();
      state = state.copyWith(isLoading: false, meongGs: meongGs);
      return meongGs;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return [];
    }
  }

  Future<String?> getLoginToken() async {
    return _kakaoLoginUsecase.getAccessToken();
  }

  Future<void> refreshLocation() async {
    await fetchCurrentLocation();
  }
}

// 3. StateNotifierProvider Definition
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel();
});
