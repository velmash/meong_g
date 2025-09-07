import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/app_styles.dart';
import 'package:meong_g/core/domain/usecases/kakao_auth_usecase.dart';
import 'package:meong_g/core/data/repositories/kakao_auth_repository_impl.dart';
import 'package:meong_g/core/network/http_client.dart';
import 'package:meong_g/core/data/datasources/auth_remote_datasource.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // 2초 대기
    await Future.delayed(Duration(seconds: 2));

    // 로그인 상태 확인 (임시로 false로 설정, 실제로는 SharedPreferences나 State Management 사용)
    bool isLoggedIn = await _checkLoginStatus();

    if (mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  Future<bool> _checkLoginStatus() async {
    try {
      final loginUsecase = KakaoAuthUsecase(KakaoAuthRepositoryImpl());
      final authDataSource = AuthRemoteDataSourceImpl();
      final isLoggedIn = await loginUsecase.isLoggedIn();
      
      if (isLoggedIn) {
        // 1. 카카오 idToken 받기
        final kakaoToken = await loginUsecase.getAccessToken();
        if (kakaoToken != null) {
          print("Splash에서 카카오 idToken: $kakaoToken");
          
          // 2. 먼저 HttpClient에 카카오 idToken 설정 (헤더용)
          HttpClient().setToken(kakaoToken);
          
          try {
            // 3. AuthRemoteDataSourceImpl 호출 (헤더에 카카오 토큰 포함하여)
            final authResponse = await authDataSource.authenticateWithKakao(
              idToken: kakaoToken,
            );
            
            final data = authResponse['data'] as Map<String, dynamic>?;
            final serverToken = data?['accessToken'] as String?;
            if (serverToken != null) {
              print("Splash에서 서버 accessToken으로 교체: $serverToken");
              HttpClient().setToken(serverToken);
            }
          } catch (e) {
            print("Splash에서 서버 인증 실패: $e");
            return false; // 서버 인증 실패시 로그인 안됨으로 처리
          }
        } else {
          print("Splash에서 카카오 토큰이 null입니다");
        }
      }
      
      return isLoggedIn;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/ic_icon.png', width: 80, height: 80),
            SizedBox(height: 20),
            Text(
              '멍 쥐 멍 멍 멍',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppStyles.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
