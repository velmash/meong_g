import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/m_toast.dart';
import '../../login/login_view.dart';
import 'my_list_card_view.dart';

enum MenuItemType {
  notification('서비스 알림 설정'),
  logout('로그아웃'),
  withdraw('탈퇴하기');

  const MenuItemType(this.title);
  final String title;
}

class MenuSectionView extends StatelessWidget {
  final dynamic viewModel;

  const MenuSectionView({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            children: [
              ...MenuItemType.values.map(
                (item) => MyListCardView(
                  title: item.title,
                  type: item.name,
                  onTap: () => _handleMenuTap(context, item, viewModel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _handleMenuTap(
  BuildContext context,
  MenuItemType type,
  dynamic viewModel,
) async {
  switch (type) {
    case MenuItemType.notification:
      Mtoast.show(context, "서비스 알림 설정");
      break;
    case MenuItemType.logout:
      await viewModel.logout();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoginView(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
          (route) => false,
        );
      }
      break;
    case MenuItemType.withdraw:
      Mtoast.show(context, "탈퇴하기");
      break;
  }
}