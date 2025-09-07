class ApiConfig {
  static const String baseUrl = 'http://meongg.asuscomm.com/api/v1';

  // API Endpoints
  static const String kakaoAuth = '/auth/kakao';
  static const String userInfo = '/members/me';

  // Headers
  static const Map<String, String> defaultHeaders = {'Content-Type': 'application/json', 'accept': '*/*'};

  static Map<String, String> authHeaders(String token) => {...defaultHeaders, 'Authorization': 'Bearer $token'};
}
