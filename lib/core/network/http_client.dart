import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  HttpClient._internal();

  String? _accessToken;

  // 토큰 설정
  void setToken(String? token) {
    print("HttpClient.setToken() 호출 - 인스턴스: ${this.hashCode}, 토큰: ${token?.substring(0, 20)}...");
    _accessToken = token;
  }

  // 토큰 제거
  void clearToken() {
    _accessToken = null;
  }

  // 토큰 가져오기
  String? get token {
    print("HttpClient.token getter 호출 - 인스턴스: ${this.hashCode}, 토큰: ${_accessToken?.substring(0, 20)}...");
    return _accessToken;
  }

  // 헤더 생성 (저장된 토큰 또는 파라미터 토큰 사용)
  Map<String, String> _getHeaders({String? token}) {
    final effectiveToken = token ?? _accessToken;
    return effectiveToken != null 
      ? ApiConfig.authHeaders(effectiveToken)
      : ApiConfig.defaultHeaders;
  }

  Future<http.Response> get(String endpoint, {String? token}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = _getHeaders(token: token);
    return await http.get(url, headers: headers);
  }

  Future<http.Response> post(String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = _getHeaders(token: token);
    return await http.post(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> put(String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = _getHeaders(token: token);
    return await http.put(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(String endpoint, {String? token}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = _getHeaders(token: token);
    return await http.delete(url, headers: headers);
  }
}