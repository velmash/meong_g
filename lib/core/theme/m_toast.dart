import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/app_styles.dart';

class Mtoast {
  static void show(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(msg, style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: AppStyles.gray900.withAlpha(200),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
