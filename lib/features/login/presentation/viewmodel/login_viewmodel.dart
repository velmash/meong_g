import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/kakao_user.dart';
import '../../domain/usecase/kakao_login_usecase.dart';
import '../../data/repository/kakao_auth_repository_impl.dart';

class LoginState {
  final bool isLoading;
  final KakaoUser? user;
  final String? errorMessage;

  LoginState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    KakaoUser? user,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  final KakaoLoginUsecase _kakaoLoginUsecase = KakaoLoginUsecase(KakaoAuthRepositoryImpl());

  LoginViewModel() : super(LoginState());

  Future<bool> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final user = await _kakaoLoginUsecase.login();
      state = state.copyWith(
        isLoading: false,
        user: user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인 실패: $e',
      );
      return false;
    }
  }

  Future<bool> checkLoginStatus() async {
    return await _kakaoLoginUsecase.isLoggedIn();
  }
}

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});