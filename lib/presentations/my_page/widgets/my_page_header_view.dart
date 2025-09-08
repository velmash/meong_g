import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/app_styles.dart';

class MyPageHeaderView extends StatelessWidget {
  const MyPageHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 0, 0),
      child: Text(
        "마이페이지",
        style: TextStyle(
          color: AppStyles.gray900,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}