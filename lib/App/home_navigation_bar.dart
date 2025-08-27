import 'package:flutter/material.dart';
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
      {'icon': Icons.document_scanner, 'label': '기록'},
      {'icon': Icons.home_outlined, 'label': '홈'},
      {'icon': Icons.person_rounded, 'label': '마이페이지'},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          backgroundColor: Colors.white,
          height: 74,
          indicatorColor: Colors.transparent,
          selectedIndex: currentPageIndex,
          destinations: navItems.map((item) {
            return NavigationDestination(
              selectedIcon: _NavigationItem(
                iconData: item['icon'] as IconData,
                label: item['label'] as String,
                isSelected: true,
              ),
              icon: _NavigationItem(
                iconData: item['icon'] as IconData,
                label: item['label'] as String,
                isSelected: false,
              ),
              label: '',
            );
          }).toList(),
        ),
      ),
      body: <Widget>[const HistoryScreen(), const HomeScrenn(), const MyPageScreen()][currentPageIndex],
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({required this.iconData, required this.label, required this.isSelected});

  final IconData iconData;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? const Color(0xFF5233FB) : const Color(0xFF7A797D);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 26),
        Icon(iconData, size: 20, color: color),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
