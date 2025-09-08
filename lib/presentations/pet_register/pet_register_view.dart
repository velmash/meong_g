import 'package:flutter/material.dart';

class PetRegisterView extends StatelessWidget {
  const PetRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("멍쥐 등록")),
      body: Center(child: Text("멍쥐 등록 구현..")),
    );
  }
}
