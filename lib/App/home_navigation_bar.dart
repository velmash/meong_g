import 'package:flutter/material.dart';
import 'package:meong_g/App/app_styles.dart';
import 'package:meong_g/screens/history_screen.dart';
import 'package:meong_g/screens/home_screen.dart';
import 'package:meong_g/screens/my_page_screen.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key});

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': AppStyles.history, 'label': '기록'},
      {'icon': AppStyles.home, 'label': '홈'},
      {'icon': AppStyles.profile, 'label': '마이페이지'},
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          backgroundColor: Colors.white,
          height: 84,
          indicatorColor: Colors.transparent,
          selectedIndex: currentPageIndex,
          destinations: navItems.map((item) {
            return NavigationDestination(
              selectedIcon: _NavigationItem(
                imagePath: item['icon'] as String,
                label: item['label'] as String,
                isSelected: true,
              ),
              icon: _NavigationItem(
                imagePath: item['icon'] as String,
                label: item['label'] as String,
                isSelected: false,
              ),
              label: '',
            );
          }).toList(),
        ),
      ),
      body: <Widget>[
        const HistoryScreen(),
        const HomeScreen(),
        const MyPageScreen(),
      ][currentPageIndex],
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.imagePath,
    required this.label,
    required this.isSelected,
  });

  final String imagePath;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppStyles.primary : AppStyles.gray500;

    final textStyle = isSelected
        ? const TextStyle(
            color: AppStyles.primary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          )
        : const TextStyle(
            color: AppStyles.gray500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Image.asset(imagePath, width: 28, height: 28, color: color),
        const SizedBox(height: 6),
        Text(label, style: textStyle),
      ],
    );
  }
}
