import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:meong_g/features/home/presentation/view/kakao_map_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const Scaffold(body: KakaoMapWidget());
    } else {
      return Scaffold(body: Center(child: Text("Not Supported OS")));
    }
  }
}
