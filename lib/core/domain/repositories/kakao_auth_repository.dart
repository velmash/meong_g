import '../entities/kakao_user.dart';

abstract class KakaoAuthRepository {
  Future<bool> isLoggedIn();
  Future<KakaoUser> login();
  Future<void> logout();
  Future<KakaoUser?> getCurrentUser();
  Future<String?> getAccessToken();
}