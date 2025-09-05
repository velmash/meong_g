import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/app_styles.dart';

class PetAddCardView extends StatelessWidget {
  final VoidCallback onProfileTap;

  const PetAddCardView({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppStyles.primary, borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppStyles.gray500, borderRadius: BorderRadius.circular(20)),
                    width: 64,
                    height: 64,
                    // child: Text("HI"),
                  ),

                  SizedBox(width: 14),

                  Text(
                    "반려견의 프로필을\n완성해 주세요!",
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(color: AppStyles.primary100, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      "반려견 프로필 등록하기",
                      style: TextStyle(color: AppStyles.primary, fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
