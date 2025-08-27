import 'package:flutter/material.dart';
import 'package:meong_g/App/home_navigation_bar.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: "Pretendard"),
      initialRoute: '/',
      routes: {'/': (context) => HomeNavigationBar()},
    ),
  );
}
