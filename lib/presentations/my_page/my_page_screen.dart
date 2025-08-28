import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "마이페이지",
        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
      ),
    );
  }
}
