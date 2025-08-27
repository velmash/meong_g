import 'package:flutter/material.dart';
import 'package:meong_g/App/home_navigation_bar.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterNaverMap().init(
    clientId: 'lrk13g1e2k',
    onAuthFailed: (ex) {
      switch (ex) {
        case NQuotaExceededException(:final message):
          print("사용량 초과 (message: $message)");
          break;
        case NUnauthorizedClientException() ||
            NClientUnspecifiedException() ||
            NAnotherAuthFailedException():
          print("인증 실패: $ex");
          break;
      }
    },
  );

  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: "Pretendard"),
      initialRoute: '/',
      routes: {'/': (context) => HomeNavigationBar()},
    ),
  );
}
