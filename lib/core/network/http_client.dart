import 'package:dio/dio.dart';
import 'api_config.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  HttpClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: ApiConfig.defaultHeaders,
        validateStatus: (status) => status != null && status < 500, // 400번대 에러도 응답으로 받기
      ),
    );
  }

  late final Dio _dio;
  String? _accessToken;

  // 토큰 설정
  void setToken(String? token) {
    _accessToken = token;
    _updateAuthHeader();
  }

  // 토큰 제거
  void clearToken() {
    _accessToken = null;
    _updateAuthHeader();
  }

  // 토큰 가져오기
  String? get token {
    return _accessToken;
  }

  // Authorization 헤더 업데이트
  void _updateAuthHeader() {
    if (_accessToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_accessToken';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  Future<Response> get(String endpoint) async {
    return await _dio.get(endpoint);
  }

  Future<Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool isMultipart = false,
  }) async {
    if (isMultipart && body != null) {
      final formData = FormData.fromMap(body);
      return await _dio.post(endpoint, data: formData);
    }

    return await _dio.post(endpoint, data: body);
  }

  Future<Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool isMultipart = false,
  }) async {
    if (isMultipart && body != null) {
      final formData = FormData.fromMap(body);
      return await _dio.put(endpoint, data: formData);
    }

    return await _dio.put(endpoint, data: body);
  }

  Future<Response> delete(String endpoint) async {
    return await _dio.delete(endpoint);
  }

  // Multipart 전용 메소드들 (호환성 유지)
  Future<Response> putMultipart(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final formData = FormData.fromMap(body);
    return await _dio.put(
      endpoint, 
      data: formData,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }
}
