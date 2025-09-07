import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:meong_g/core/widget/home_navigation_bar.dart';
import 'package:meong_g/presentations/login/login_view.dart';
import 'package:meong_g/presentations/splash/splash_view.dart';

void main() {
  // 카카오 SDK 초기화 - 실제 네이티브 앱 키를 여기에 입력해야 합니다
  KakaoSdk.init(
    nativeAppKey:
        'e7e182f9fcbcd12f8dd842a99926e5da', // 카카오 개발자센터에서 발급받은 네이티브 앱 키
  );

  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Pretendard"),
        home: SplashView(),
        routes: {
          '/home': (context) => HomeNavigationBar(),
          '/login': (context) => LoginView(),
        },
      ),
    ),
  );
}
