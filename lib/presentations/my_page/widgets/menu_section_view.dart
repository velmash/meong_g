import 'package:flutter/material.dart';
import 'package:meong_g/core/theme/m_toast.dart';
import '../../login/login_view.dart';
import 'my_list_card_view.dart';

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
              ...menuItems.map(
                (item) => MyListCardView(
                  title: item['title'],
                  type: item['type'],
                  onTap: () => _handleMenuTap(context, item['type'], viewModel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 메뉴 데이터
final List<Map<String, dynamic>> menuItems = [
  {'title': '서비스 알림 설정', 'type': 'notification'},
  {'title': '로그아웃', 'type': 'logout'},
  {'title': '탈퇴하기', 'type': 'withdraw'},
];

// 메뉴 탭 처리
void _handleMenuTap(
  BuildContext context,
  String type,
  dynamic viewModel,
) async {
  switch (type) {
    case 'notification':
      Mtoast.show(context, "서비스 알림 설정");
      break;
    case 'logout':
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
    case 'withdraw':
      Mtoast.show(context, "탈퇴하기");
      break;
  }
}