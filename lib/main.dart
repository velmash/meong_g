import 'package:flutter/material.dart';
import 'package:meong_g/screens/home_navigation_bar.dart';

void main() {
  runApp(MaterialApp(initialRoute: '/', routes: {'/': (context) => HomeNavigationBar()}));
}
