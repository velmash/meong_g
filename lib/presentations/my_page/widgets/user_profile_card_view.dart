import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/app_styles.dart';

class UserProfileCardView extends StatelessWidget {
  final String? nickname;
  final String? introduction;
  final VoidCallback onEditTap;

  const UserProfileCardView({
    super.key,
    this.nickname,
    this.introduction,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 12, 0),
          child: Container(
            height: 72,
            width: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppStyles.gray300,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              (nickname?.isNotEmpty == true) ? nickname! : "사용자를 등록해주세요.",
              style: TextStyle(
                color: AppStyles.gray900,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              (introduction?.isNotEmpty == true) ? introduction! : "소개 문구",
              style: TextStyle(
                color: AppStyles.gray500,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: onEditTap,
            child: Image.asset(
              'assets/img/ic_pencil.png',
              width: 24,
              height: 24,
              color: AppStyles.gray500,
            ),
          ),
        ),
      ],
    );
  }
}
