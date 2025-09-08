import 'package:flutter/material.dart';

class AlarmView extends StatelessWidget {
  const AlarmView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("알림 확인")),
      body: Center(child: Text("알림 확인 구현..")),
    );
  }
}
