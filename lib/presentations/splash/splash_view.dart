import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/app_styles.dart';
import 'package:meong_g/core/domain/usecases/kakao_auth_usecase.dart';
import 'package:meong_g/core/data/repositories/kakao_auth_repository_impl.dart';

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
      return await loginUsecase.isLoggedIn();
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
