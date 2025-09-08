import 'package:flutter/material.dart';

class UserRegisterView extends StatelessWidget {
  const UserRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("유저 등록")),
      body: Center(child: Text("유저 등록 구현..")),
    );
  }
}
