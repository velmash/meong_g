import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/kakao_user.dart';
import '../../domain/usecase/kakao_login_usecase.dart';
import '../../data/repository/kakao_auth_repository_impl.dart';

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
  final KakaoLoginUsecase _kakaoLoginUsecase = KakaoLoginUsecase(KakaoAuthRepositoryImpl());

  MyPageViewModel() : super(MyPageState());

  Future<void> checkLoginStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final isLoggedIn = await _kakaoLoginUsecase.isLoggedIn();
      if (isLoggedIn) {
        final user = await _kakaoLoginUsecase.getCurrentUser();
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

  Future<void> login() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final user = await _kakaoLoginUsecase.login();
      state = state.copyWith(
        isLoggedIn: true,
        user: user,
        isLoading: false,
      );
    } catch (e) {
      print('로그인 실패: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _kakaoLoginUsecase.logout();
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
    return await _kakaoLoginUsecase.getAccessToken();
  }
}

final myPageViewModelProvider = StateNotifierProvider<MyPageViewModel, MyPageState>((ref) {
  return MyPageViewModel();
});