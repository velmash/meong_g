import 'package:meong_g/core/domain/entities/user_info.dart';
import 'package:meong_g/core/domain/repositories/user_repository.dart';
import 'package:meong_g/core/network/api_config.dart';
import 'package:meong_g/core/network/http_client.dart';
import 'package:meong_g/core/data/dto/user_info_dto.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserInfo> getUserInfo() async {
    final HttpClient httpClient = HttpClient();

    try {
      final response = await httpClient.get(ApiConfig.userInfo);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = response.data;

        final dto = UserInfoDto.fromJson(jsonMap);

        if (dto.error != null) {
          // 서버가 에러 응답을 내려준 경우
          throw dto.error!;
        }

        final userInfo = dto.toUserInfo();
        if (userInfo == null) {
          throw Exception('UserInfo parsing failed');
        }
        return userInfo;
      } else {
        throw Exception('Failed to load user info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error during getUserInfo: $e');
    }
  }

  @override
  Future<void> updateUserInfo(UserInfo userInfo) async {
    final HttpClient httpClient = HttpClient();

    try {
      final requestBody = userInfo.toJson();
      final response = await httpClient.putMultipart(
        ApiConfig.userInfo,
        requestBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = response.data;
        final dto = UserInfoDto.fromJson(jsonMap);

        if (dto.error != null) {
          throw dto.error!;
        }
        return;
      } else {
        final errorBody = response.data != null
            ? response.data.toString()
            : 'No response body';
        throw Exception('HTTP ${response.statusCode}: $errorBody');
      }
    } catch (e) {
      rethrow; // 원본 에러를 다시 던짐
    }
  }
}
