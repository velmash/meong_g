import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/usecases/kakao_auth_usecase.dart';
import '../../core/data/repositories/kakao_auth_repository_impl.dart';
import '../../core/network/http_client.dart';
import '../../core/data/datasources/auth_remote_datasource.dart';

class SplashState {
  final bool isLoading;
  final String? errorMessage;

  SplashState({this.isLoading = true, this.errorMessage});

  SplashState copyWith({bool? isLoading, String? errorMessage}) {
    return SplashState(isLoading: isLoading ?? this.isLoading, errorMessage: errorMessage ?? this.errorMessage);
  }
}

class SplashViewModel extends StateNotifier<SplashState> {
  final KakaoAuthUsecase _kakaoAuthUsecase = KakaoAuthUsecase(KakaoAuthRepositoryImpl());
  final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSourceImpl();

  SplashViewModel() : super(SplashState());

  Future<bool> checkLoginStatus() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final isLoggedIn = await _kakaoAuthUsecase.isLoggedIn();

      if (isLoggedIn) {
        // 1. 카카오 idToken 받기
        final kakaoToken = await _kakaoAuthUsecase.getAccessToken();
        if (kakaoToken != null) {
          // 2. 먼저 HttpClient에 카카오 idToken 설정 (헤더용)
          HttpClient().setToken(kakaoToken);

          try {
            // 3. AuthRemoteDataSourceImpl 호출 (헤더에 카카오 토큰 포함하여)
            final authResponse = await _authRemoteDataSource.authenticateWithKakao(idToken: kakaoToken);

            final data = authResponse['data'] as Map<String, dynamic>?;
            final serverToken = data?['accessToken'] as String?;
            if (serverToken != null) {
              HttpClient().setToken(serverToken);
            } else {
              print("서버 accessToken이 null입니다. authResponse: $authResponse");
            }
          } catch (e) {
            print("Splash에서 서버 인증 실패: $e");
            state = state.copyWith(isLoading: false, errorMessage: e.toString());
            return false; // 서버 인증 실패시 로그인 안됨으로 처리
          }
        } else {
          print("Splash에서 카카오 토큰이 null입니다");
        }
      }

      state = state.copyWith(isLoading: false);
      return isLoggedIn;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, SplashState>((ref) {
  return SplashViewModel();
});
