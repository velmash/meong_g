import '../entity/kakao_user.dart';
import '../repository/kakao_auth_repository.dart';

class KakaoUserUsecase {
  final KakaoAuthRepository _repository;

  KakaoUserUsecase(this._repository);

  Future<bool> isLoggedIn() async {
    return await _repository.isLoggedIn();
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