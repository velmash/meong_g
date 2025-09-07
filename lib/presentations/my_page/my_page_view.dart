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
          // mainAxisAlignment:
          // MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 0, 0),
              child: Text(
                "마이페이지",
                style: TextStyle(color: AppStyles.gray900, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 34),

            if (state.isLoading)
              CircularProgressIndicator()
            else if (state.isLoggedIn && state.userInfo != null) ...[
              Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 12, 0),
                      child: Container(
                        height: 72,
                        width: 72,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppStyles.gray300, shape: BoxShape.circle),
                        // child: Text('Main'),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          (state.userInfo!.nickname?.isNotEmpty == true) ? state.userInfo!.nickname! : "사용자를 등록해주세요.",
                          style: TextStyle(color: AppStyles.gray900, fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        Text(
                          (state.userInfo!.introduction?.isNotEmpty == true) ? state.userInfo!.introduction! : "소개 문구",
                          style: TextStyle(color: AppStyles.gray500, fontSize: 16, fontWeight: FontWeight.w400),
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
                        child: Image.asset('assets/img/ic_pencil.png', width: 24, height: 24, color: AppStyles.gray500),
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),

              GestureDetector(
                onTap: () async {
                  await viewModel.logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => LoginView(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  width: 120,
                  height: 60,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      "로그아웃",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ] else
              GestureDetector(
                // onTap: () => viewModel.login(),
                onTap: () => print("HI"),
                child: Container(
                  width: 120,
                  height: 60,
                  decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      "카카오 로그인",
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
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
