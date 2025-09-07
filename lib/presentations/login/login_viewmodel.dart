import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/entities/kakao_user.dart';
import '../../core/domain/usecases/kakao_auth_usecase.dart';
import '../../core/data/repositories/kakao_auth_repository_impl.dart';
import '../../core/network/http_client.dart';
import '../../core/data/datasources/auth_remote_datasource.dart';

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
  final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSourceImpl();

  LoginViewModel() : super(LoginState());

  Future<bool> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      // 1. 카카오 로그인
      final user = await _kakaoAuthUsecase.login();
      
      // 2. 카카오 idToken 가져오기
      final kakaoToken = await _kakaoAuthUsecase.getAccessToken();
      if (kakaoToken == null) {
        throw Exception('카카오 토큰을 가져올 수 없습니다');
      }
      
      print("Login에서 카카오 idToken: $kakaoToken");
      
      // 3. 먼저 HttpClient에 카카오 idToken 설정 (헤더용)
      HttpClient().setToken(kakaoToken);
      
      // 4. AuthRemoteDataSourceImpl 호출 (헤더에 카카오 토큰 포함하여)
      final authResponse = await _authRemoteDataSource.authenticateWithKakao(
        idToken: kakaoToken,
      );
      
      // 5. 서버 accessToken으로 HttpClient 토큰 교체
      final data = authResponse['data'] as Map<String, dynamic>?;
      final serverToken = data?['accessToken'] as String?;
      if (serverToken != null) {
        print("Login에서 서버 accessToken으로 교체: $serverToken");
        HttpClient().setToken(serverToken);
      } else {
        throw Exception('서버에서 accessToken을 받지 못했습니다');
      }
      
      state = state.copyWith(
        isLoading: false,
        user: user,
      );
      return true;
    } catch (e) {
      print("로그인 에러: $e");
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