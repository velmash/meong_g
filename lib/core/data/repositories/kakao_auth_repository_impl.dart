import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../domain/entities/kakao_user.dart';
import '../../domain/repositories/kakao_auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../network/http_client.dart';

class KakaoAuthRepositoryImpl implements KakaoAuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSourceImpl();
  final HttpClient _httpClient = HttpClient();

  @override
  Future<bool> isLoggedIn() async {
    try {
      await UserApi.instance.accessTokenInfo();

      // 로그인 상태일 때 토큰을 HttpClient에 설정
      final token = await TokenManagerProvider.instance.manager.getToken();
      _httpClient.setToken(token?.idToken);

      return true;
    } catch (e) {
      // 로그인 안된 상태일 때 토큰 제거
      _httpClient.clearToken();
      return false;
    }
  }

  @override
  Future<KakaoUser> login() async {
    try {
      // 1. 카카오 로그인
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      // 2. 카카오 사용자 정보 및 토큰 가져오기
      final user = await UserApi.instance.me();
      final token = await TokenManagerProvider.instance.manager.getToken();

      if (token?.idToken == null) {
        throw Exception('카카오 ID 토큰을 가져올 수 없습니다');
      }

      // 3. HttpClient에 토큰 먼저 설정 (서버 인증에 필요)
      _httpClient.setToken(token!.idToken);

      // 4. 서버 인증
      await _authRemoteDataSource.authenticateWithKakao(
        idToken: token.idToken!,
      );

      // 5. 사용자 정보 반환
      return KakaoUser(
        id: user.id.toString(),
        nickname: user.kakaoAccount?.profile?.nickname,
        profileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
        email: user.kakaoAccount?.email,
      );
    } catch (e) {
      throw Exception('로그인 실패: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await UserApi.instance.unlink();
      // 로그아웃 시 토큰 제거
      _httpClient.clearToken();
    } catch (e) {
      throw Exception('카카오 로그아웃 실패: $e');
    }
  }

  @override
  Future<KakaoUser?> getCurrentUser() async {
    try {
      if (!await isLoggedIn()) return null;

      final user = await UserApi.instance.me();
      return KakaoUser(
        id: user.id.toString(),
        nickname: user.kakaoAccount?.profile?.nickname,
        profileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
        email: user.kakaoAccount?.email,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      final token = await TokenManagerProvider.instance.manager.getToken();
      return token?.idToken;
    } catch (e) {
      return null;
    }
  }
}
