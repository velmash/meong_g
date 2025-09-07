import 'package:meong_g/core/domain/entities/user_info.dart';

abstract class UserRepository {
  Future<UserInfo> getUserInfo();
}
