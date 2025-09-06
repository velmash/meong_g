import '../entity/kakao_user.dart';
import '../repository/kakao_auth_repository.dart';

class KakaoLoginUsecase {
  final KakaoAuthRepository _repository;

  KakaoLoginUsecase(this._repository);

  Future<bool> isLoggedIn() async {
    return await _repository.isLoggedIn();
  }

  Future<KakaoUser> login() async {
    return await _repository.login();
  }

  Future<void> logout() async {
    return await _repository.logout();
  }

  Future<KakaoUser?> getCurrentUser() async {
    return await _repository.getCurrentUser();
  }

  Future<String?> getAccessToken() async {
    return await _repository.getAccessToken();
  }
}