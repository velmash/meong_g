import 'dart:convert';
import 'package:meong_g/core/domain/entities/user_info.dart';
import 'package:meong_g/core/domain/repositories/user_repository.dart';
import 'package:meong_g/core/network/api_config.dart';
import 'package:meong_g/core/network/http_client.dart';
import 'package:meong_g/core/data/dto/user_info_dto.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserInfo> getUserInfo() async {
    final HttpClient httpClient = HttpClient();

    // 디버깅: 토큰 확인
    print("HttpClient 토큰: ${httpClient.token}");

    try {
      final response = await httpClient.get(ApiConfig.userInfo);

      // 디버깅: 요청 정보 출력
      print("요청 URL: ${ApiConfig.userInfo}");
      print("응답 상태 코드: ${response.statusCode}");
      print("응답 내용: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);

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
}
