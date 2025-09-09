import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/app_styles.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const ProfileImageWidget({super.key, this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppStyles.gray300,
            ),
            child: imagePath != null
                ? ClipOval(
                    child: Image.network(
                      imagePath!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppStyles.gray300,
                          ),
                        );
                      },
                    ),
                  )
                : null,
          ),
          Positioned(
            right: 1,
            bottom: 1,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        offset: const Offset(1, 1),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/img/ic_camera.png',
                    width: 18,
                    height: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
