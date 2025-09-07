import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/core/theme/app_styles.dart';
import 'package:meong_g/core/theme/m_toast.dart';
import 'package:meong_g/features/login/presentation/viewmodel/login_viewmodel.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginViewModel = ref.read(loginViewModelProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 80, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "설레는\n산책의 시작,",
                    style: TextStyle(
                      color: AppStyles.gray900,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "멍쥐",
                        style: TextStyle(
                          color: AppStyles.primary700,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Image.asset(
                        'assets/img/ic_icon.png',
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                spacing: 8,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppStyles.kakaoColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 56,
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () async {
                        if (loginState.isLoading) return;
                        
                        final success = await loginViewModel.login();
                        if (success) {
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        } else {
                          if (context.mounted) {
                            Mtoast.show(context, loginState.errorMessage ?? "로그인에 실패했습니다");
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          Positioned(
                            left: 20,
                            top: 0,
                            bottom: 0,
                            child: Image.asset(
                              'assets/img/ic_kakao.png',
                              width: 48,
                              height: 48,
                            ),
                          ),
                          Center(
                            child: Text(
                              "카카오톡으로 로그인",
                              style: TextStyle(
                                color: AppStyles.gray900,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: AppStyles.naverColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 56,
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        Mtoast.show(context, "카카오 로그인 하셈 ㅋㅋ");
                      },
                      child: Stack(
                        children: [
                          Positioned(
                            left: 20,
                            top: 0,
                            bottom: 0,
                            child: Image.asset(
                              'assets/img/ic_naver.png',
                              width: 48,
                              height: 48,
                            ),
                          ),
                          Center(
                            child: Text(
                              "네이버로 로그인",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppStyles.gray50),
                    ),
                    height: 56,
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        Mtoast.show(context, "카카오 로그인 하셈 ㅋㅋ");
                      },
                      child: Stack(
                        children: [
                          Positioned(
                            left: 20,
                            top: 0,
                            bottom: 0,
                            child: Image.asset(
                              'assets/img/ic_google.png',
                              width: 48,
                              height: 48,
                            ),
                          ),
                          Center(
                            child: Text(
                              "구글로 로그인",
                              style: TextStyle(
                                color: AppStyles.gray900,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  GestureDetector(
                    onTap: () {
                      Mtoast.show(context, "로그인 안하면 못씀 ㅋㅋ");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppStyles.gray400,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Text(
                        "로그인 없이 멍쥐 둘러보기",
                        style: TextStyle(color: AppStyles.gray400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
