import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/core/data/repositories/user_repository_impl.dart';
import 'package:meong_g/core/domain/entities/user_info.dart';
import 'package:meong_g/core/domain/usecases/user_usecase.dart';
import '../../core/domain/usecases/kakao_auth_usecase.dart';
import '../../core/data/repositories/kakao_auth_repository_impl.dart';
import '../../core/network/http_client.dart';
import '../user_register/user_register_view.dart';

class MyPageState {
  final bool isLoggedIn;
  final bool isLoading;
  final String errorMessage;
  final int petCount;
  final UserInfo? userInfo;

  const MyPageState({
    this.isLoggedIn = false,
    this.isLoading = false,
    this.errorMessage = '',
    this.petCount = 2,
    this.userInfo,
  });

  MyPageState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? errorMessage,
    int? petCount,
    UserInfo? userInfo,
  }) {
    return MyPageState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      petCount: petCount ?? this.petCount,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}

class MyPageViewModel extends StateNotifier<MyPageState> {
  final KakaoAuthUsecase _kakaoAuthUsecase = KakaoAuthUsecase(KakaoAuthRepositoryImpl());
  final UserUsecase _userUsecase = UserUsecase(UserRepositoryImpl());

  MyPageViewModel() : super(MyPageState());

  Future<void> checkLoginStatus() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final isLoggedIn = await _kakaoAuthUsecase.isLoggedIn();
      if (isLoggedIn) {
        final userInfo = await _userUsecase.getUserInfo();
        state = state.copyWith(
          isLoggedIn: true,
          userInfo: userInfo,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoggedIn: false,
          userInfo: null,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoggedIn: false,
        userInfo: null,
        isLoading: false,
        errorMessage: 'getUserInfo 에러: $e',
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      await _kakaoAuthUsecase.logout();
      HttpClient().clearToken();
      
      state = state.copyWith(
        isLoggedIn: false,
        userInfo: null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그아웃 실패: $e',
      );
    }
  }

  Future<void> getUserInfo() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final userInfo = await _userUsecase.getUserInfo();
      state = state.copyWith(
        userInfo: userInfo,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'getUserInfo 에러: $e',
      );
    }
  }

  void navigateToUserRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserRegisterView(userInfo: state.userInfo),
      ),
    );
  }
}

final myPageViewModelProvider = StateNotifierProvider<MyPageViewModel, MyPageState>((ref) {
  return MyPageViewModel();
});
