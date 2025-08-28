import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:meong_g/kakao_map_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const Scaffold(body: IOSKakaoMapView());
    } else {
      return Scaffold(body: Center(child: Text("Not Supported OS")));
    }
  }
}
