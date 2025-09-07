import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/entities/kakao_user.dart';
import '../../core/domain/usecases/kakao_auth_usecase.dart';
import '../../core/data/repositories/kakao_auth_repository_impl.dart';

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
  final KakaoAuthUsecase _kakaoAuthUsecase = KakaoAuthUsecase(KakaoAuthRepositoryImpl());

  LoginViewModel() : super(LoginState());

  Future<bool> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final user = await _kakaoAuthUsecase.login();
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
    return await _kakaoAuthUsecase.isLoggedIn();
  }
}

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});