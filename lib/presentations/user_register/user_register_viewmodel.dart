import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/core/domain/entities/user_info.dart';
import 'package:meong_g/core/domain/usecases/user_usecase.dart';
import 'package:meong_g/core/data/repositories/user_repository_impl.dart';
import 'models/user_register_state.dart';

class UserRegisterViewModel extends StateNotifier<UserRegisterState> {
  final UserUsecase _userUsecase = UserUsecase(UserRepositoryImpl());

  UserRegisterViewModel({UserInfo? initialUserInfo})
    : super(
        UserRegisterState(
          userInfo: initialUserInfo,
          name: initialUserInfo?.nickname ?? '',
          introduction: initialUserInfo?.introduction ?? '',
        ),
      );

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateIntroduction(String introduction) {
    state = state.copyWith(introduction: introduction);
  }

  void updateProfileImage(String? imagePath) {
    state = state.copyWith(profileImagePath: imagePath);
  }

  Future<void> saveUserProfile() async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: '이름을 입력해주세요.');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final updatedUserInfo = UserInfo(
        nickname: state.name,
        introduction: state.introduction,
        profileImageFileName: state.profileImagePath ?? '',
        authType: state.userInfo?.authType,
      );

      await _userUsecase.updateUserInfo(updatedUserInfo);

      state = state.copyWith(isLoading: false, userInfo: updatedUserInfo);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '프로필 저장에 실패했습니다: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: '');
  }

  void reset() {
    state = UserRegisterState(
      userInfo: state.userInfo,
      name: state.userInfo?.nickname ?? '',
      introduction: state.userInfo?.introduction ?? '',
    );
  }
}

final userRegisterViewModelProvider =
    StateNotifierProvider.family<
      UserRegisterViewModel,
      UserRegisterState,
      UserInfo?
    >(
      (ref, initialUserInfo) =>
          UserRegisterViewModel(initialUserInfo: initialUserInfo),
    );
