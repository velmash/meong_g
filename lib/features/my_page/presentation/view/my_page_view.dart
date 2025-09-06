import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/my_page_viewmodel.dart';

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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "마이페이지",
            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 16),

          if (state.isLoading)
            CircularProgressIndicator()
          else if (state.isLoggedIn && state.user != null) ...[
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  if (state.user!.profileImageUrl != null)
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(state.user!.profileImageUrl!),
                    ),
                  SizedBox(height: 8),
                  Text(
                    state.user!.nickname ?? "사용자",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  if (state.user!.email != null)
                    Text(
                      state.user!.email!,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => viewModel.logout(),
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
              onTap: () => viewModel.login(),
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
    );
  }
}
