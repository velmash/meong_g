import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/core/data/repositories/user_repository_impl.dart';
import 'package:meong_g/core/domain/entities/user_info.dart';
import 'package:meong_g/core/domain/usecases/user_usecase.dart';
import '../../core/domain/usecases/kakao_auth_usecase.dart';
import '../../core/data/repositories/kakao_auth_repository_impl.dart';
import '../../core/network/http_client.dart';

class MyPageState {
  final bool isLoggedIn;
  final UserInfo? userInfo;
  final bool isLoading;

  MyPageState({this.isLoggedIn = false, this.userInfo, this.isLoading = false});

  MyPageState copyWith({bool? isLoggedIn, UserInfo? userInfo, bool? isLoading}) {
    return MyPageState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userInfo: userInfo ?? this.userInfo,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MyPageViewModel extends StateNotifier<MyPageState> {
  final KakaoAuthUsecase _kakaoAuthUsecase = KakaoAuthUsecase(KakaoAuthRepositoryImpl());
  final UserUsecase _userUsecase = UserUsecase(UserRepositoryImpl());

  MyPageViewModel() : super(MyPageState());

  Future<void> checkLoginStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final isLoggedIn = await _kakaoAuthUsecase.isLoggedIn();
      if (isLoggedIn) {
        final userInfo = await _userUsecase.getUserInfo();
        state = state.copyWith(isLoggedIn: true, userInfo: userInfo, isLoading: false);
      } else {
        state = state.copyWith(isLoggedIn: false, userInfo: null, isLoading: false);
      }
    } catch (e) {
      print("MyPage getUserInfo 에러: $e");
      state = state.copyWith(isLoggedIn: false, userInfo: null, isLoading: false);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _kakaoAuthUsecase.logout();

      // 로그아웃 후 HttpClient에서 토큰 제거
      HttpClient().clearToken();

      state = state.copyWith(isLoggedIn: false, userInfo: null, isLoading: false);
    } catch (e) {
      print('로그아웃 실패: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<UserInfo> getUserInfo() async {
    return await _userUsecase.getUserInfo();
  }
}

final myPageViewModelProvider = StateNotifierProvider<MyPageViewModel, MyPageState>((ref) {
  return MyPageViewModel();
});
