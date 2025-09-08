import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/app_styles.dart';
import 'package:meong_g/core/theme/m_toast.dart';

class PetSectionView extends StatelessWidget {
  final int petCount;
  final VoidCallback? onAddPetTap;

  const PetSectionView({
    super.key,
    this.petCount = 0,
    this.onAddPetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "나의 반려견",
                style: TextStyle(
                  color: AppStyles.gray900,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                petCount.toString(),
                style: TextStyle(
                  color: AppStyles.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: onAddPetTap ?? () => Mtoast.show(context, "구현해라.."),
                child: Text(
                  "+ 반려견 추가하기",
                  style: TextStyle(
                    color: AppStyles.gray500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.amber,
            ),
            child: Center(child: Text("//TODO: - 개정보")),
          ),
        ),
      ],
    );
  }
}