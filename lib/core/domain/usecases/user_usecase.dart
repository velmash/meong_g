import 'package:meong_g/core/domain/entities/user_info.dart';
import 'package:meong_g/core/domain/repositories/user_repository.dart';

class UserUsecase {
  final UserRepository _repository;

  UserUsecase(this._repository);

  Future<UserInfo> getUserInfo() async {
    return _repository.getUserInfo();
  }

  Future<void> updateUserInfo(UserInfo userInfo) async {
    return _repository.updateUserInfo(userInfo);
  }
}
