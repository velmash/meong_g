import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/core/theme/app_styles.dart';
import 'package:meong_g/core/theme/m_toast.dart';
import 'my_page_viewmodel.dart';
import '../login/login_view.dart';

class MyPageView extends ConsumerStatefulWidget {
  const MyPageView({super.key});

  @override
  ConsumerState<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends ConsumerState<MyPageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myPageViewModelProvider.notifier).checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myPageViewModelProvider);
    final viewModel = ref.read(myPageViewModelProvider.notifier);

    return Container(
      color: AppStyles.gray50,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 0, 0),
              child: Text(
                "마이페이지",
                style: TextStyle(
                  color: AppStyles.gray900,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 34),

            if (state.isLoading)
              CircularProgressIndicator()
            else
              Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 12, 0),
                      child: Container(
                        height: 72,
                        width: 72,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppStyles.gray300,
                          shape: BoxShape.circle,
                        ),
                        // child: Text('Main'),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          (state.userInfo?.nickname?.isNotEmpty == true)
                              ? state.userInfo!.nickname!
                              : "사용자를 등록해주세요.",
                          style: TextStyle(
                            color: AppStyles.gray900,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          (state.userInfo?.introduction?.isNotEmpty == true)
                              ? state.userInfo!.introduction!
                              : "소개 문구",
                          style: TextStyle(
                            color: AppStyles.gray500,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                          Mtoast.show(context, "구현..");
                        },
                        child: Image.asset(
                          'assets/img/ic_pencil.png',
                          width: 24,
                          height: 24,
                          color: AppStyles.gray500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 28),

            Container(
              child: Column(
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
                          "2",
                          style: TextStyle(
                            color: AppStyles.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Mtoast.show(context, "구현해라..");
                          },
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
              ),
            ),

            SizedBox(height: 20),
            // Spacer(),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    children: [
                      ...menuItems.map(
                        (item) => MyListCard(
                          title: item['title'],
                          type: item['type'],
                          onTap: () =>
                              _handleMenuTap(context, item['type'], viewModel),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

class MyListCard extends StatefulWidget {
  final String title;
  final String type;
  final VoidCallback onTap;
  final bool isSelected;

  const MyListCard({
    super.key,
    required this.title,
    required this.type,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<MyListCard> createState() => _MyListCardState();
}

class _MyListCardState extends State<MyListCard> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
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
            // 로그아웃, 탈퇴하기는 다른 색상으로 표시할 수도 있음
            if (widget.type == 'notification')
              // 토글 스위치나 화살표 아이콘 추가 가능
              Switch(
                activeThumbColor: AppStyles.primary400,
                inactiveThumbColor: AppStyles.gray200,
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
