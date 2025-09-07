import 'package:flutter/material.dart';
import 'package:meong_g/core/domain/entities/meong_g.dart';
import 'package:meong_g/core/theme/app_styles.dart';

class PetInfoCardView extends StatelessWidget {
  final MeongG meongGInfo;

  const PetInfoCardView({super.key, required this.meongGInfo});

  @override
  Widget build(BuildContext context) {
    final imageUrl = _ImageUtils.convertGoogleDriveUrl(meongGInfo.imageUrl);
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  _PetAvatar(imageUrl: imageUrl),

                  SizedBox(width: 14),

                  _PetInfo(meongG: meongGInfo),
                ],
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _PetStatButton(label: "오늘 산책", value: "0회"),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _PetStatButton(label: "산책 시간", value: "0분"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetStatButton extends StatelessWidget {
  final String label;
  final String value;

  const _PetStatButton({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppStyles.primary700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  final String imageUrl;

  const _PetAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppStyles.gray500,
                    child: Icon(Icons.pets, color: Colors.white, size: 32),
                  );
                },
              )
            : Icon(Icons.pets, color: Colors.white, size: 32),
      ),
    );
  }
}

class _PetInfo extends StatelessWidget {
  final MeongG meongG;

  const _PetInfo({required this.meongG});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          meongG.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Text(
              "${meongG.breed} · ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              "${meongG.age}살",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImageUtils {
  static String convertGoogleDriveUrl(String url) {
    if (url.contains('drive.google.com/file/d/')) {
      final fileId = url.split('/d/')[1].split('/')[0];
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    }
    return url;
  }
}
