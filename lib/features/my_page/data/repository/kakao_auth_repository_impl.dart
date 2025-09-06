import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../domain/entity/kakao_user.dart';
import '../../domain/repository/kakao_auth_repository.dart';

class KakaoAuthRepositoryImpl implements KakaoAuthRepository {
  @override
  Future<bool> isLoggedIn() async {
    try {
      await UserApi.instance.accessTokenInfo();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<KakaoUser> login() async {
    try {
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }
      
      final user = await UserApi.instance.me();
      return KakaoUser(
        id: user.id.toString(),
        nickname: user.kakaoAccount?.profile?.nickname,
        profileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
        email: user.kakaoAccount?.email,
      );
    } catch (e) {
      throw Exception('카카오 로그인 실패: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await UserApi.instance.unlink();
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
      return token?.accessToken;
    } catch (e) {
      return null;
    }
  }
}