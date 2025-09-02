import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/core/widget/home_navigation_bar.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Pretendard"),
        initialRoute: '/',
        routes: {'/': (context) => HomeNavigationBar()},
      ),
    ),
  );
}