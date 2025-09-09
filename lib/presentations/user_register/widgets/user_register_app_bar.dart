import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/app_styles.dart';

class UserRegisterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onComplete;
  final bool isLoading;
  final bool isValid;

  const UserRegisterAppBar({
    super.key,
    required this.onComplete,
    this.isLoading = false,
    this.isValid = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 64,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: isLoading ? null : () => Navigator.of(context).pop(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: (isLoading || !isValid) ? null : onComplete,
            child: AnimatedOpacity(
              opacity: (isLoading || !isValid) ? 0.5 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppStyles.primary500,
                      ),
                    )
                  : Text(
                      "완료",
                      style: TextStyle(
                        color: isValid ? AppStyles.primary500 : AppStyles.gray400,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}