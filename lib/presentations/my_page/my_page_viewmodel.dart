import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/entities/kakao_user.dart';
import '../../core/domain/usecases/kakao_auth_usecase.dart';
import '../../core/data/repositories/kakao_auth_repository_impl.dart';

class MyPageState {
  final bool isLoggedIn;
  final KakaoUser? user;
  final bool isLoading;

  MyPageState({
    this.isLoggedIn = false,
    this.user,
    this.isLoading = false,
  });

  MyPageState copyWith({
    bool? isLoggedIn,
    KakaoUser? user,
    bool? isLoading,
  }) {
    return MyPageState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MyPageViewModel extends StateNotifier<MyPageState> {
  final KakaoAuthUsecase _kakaoAuthUsecase = KakaoAuthUsecase(KakaoAuthRepositoryImpl());

  MyPageViewModel() : super(MyPageState());

  Future<void> checkLoginStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final isLoggedIn = await _kakaoAuthUsecase.isLoggedIn();
      if (isLoggedIn) {
        final user = await _kakaoAuthUsecase.getCurrentUser();
        state = state.copyWith(
          isLoggedIn: true,
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoggedIn: false,
          user: null,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoggedIn: false,
        user: null,
        isLoading: false,
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _kakaoAuthUsecase.logout();
      state = state.copyWith(
        isLoggedIn: false,
        user: null,
        isLoading: false,
      );
    } catch (e) {
      print('로그아웃 실패: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<String?> getAccessToken() async {
    return await _kakaoAuthUsecase.getAccessToken();
  }
}

final myPageViewModelProvider = StateNotifierProvider<MyPageViewModel, MyPageState>((ref) {
  return MyPageViewModel();
});