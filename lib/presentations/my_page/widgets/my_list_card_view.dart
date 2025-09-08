import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/app_styles.dart';

class MyListCardView extends StatefulWidget {
  final String title;
  final String type;
  final VoidCallback onTap;
  final bool initialSelected;

  const MyListCardView({
    super.key,
    required this.title,
    required this.type,
    required this.onTap,
    this.initialSelected = false,
  });

  @override
  State<MyListCardView> createState() => _MyListCardViewState();
}

class _MyListCardViewState extends State<MyListCardView> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppStyles.gray50, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: AppStyles.gray800,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (widget.type == 'notification')
              Switch(
                activeThumbColor: AppStyles.primary400,
                inactiveThumbColor: AppStyles.gray300,
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    isSelected = value;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}