import '../../network/http_client.dart';
import '../../network/api_config.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> authenticateWithKakao({required String idToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpClient _httpClient = HttpClient();

  @override
  Future<Map<String, dynamic>> authenticateWithKakao({
    required String idToken,
  }) async {
    try {
      final response = await _httpClient.post(
        ApiConfig.kakaoAuth,
        body: {'idToken': idToken},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Server authentication failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error during authentication: $e');
    }
  }
}
