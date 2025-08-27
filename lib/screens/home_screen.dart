import 'package:flutter/material.dart';

class HomeScrenn extends StatelessWidget {
  const HomeScrenn({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "임요환 징얼충\n남성호소인",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
      ),
    );
  }
}
