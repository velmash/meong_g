import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "기록",
        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
      ),
    );
  }
}
