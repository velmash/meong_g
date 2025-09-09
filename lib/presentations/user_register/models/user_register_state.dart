import 'package:meong_g/core/domain/entities/user_info.dart';

class UserRegisterState {
  final bool isLoading;
  final String errorMessage;
  final UserInfo? userInfo;
  final String name;
  final String introduction;
  final String? profileImagePath;

  const UserRegisterState({
    this.isLoading = false,
    this.errorMessage = '',
    this.userInfo,
    this.name = '',
    this.introduction = '',
    this.profileImagePath,
  });

  UserRegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserInfo? userInfo,
    String? name,
    String? introduction,
    String? profileImagePath,
  }) {
    return UserRegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      userInfo: userInfo ?? this.userInfo,
      name: name ?? this.name,
      introduction: introduction ?? this.introduction,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  String get authTypeDisplayText {
    return userInfo?.authType?.displayText ?? '';
  }

  bool get hasChanges {
    if (userInfo == null) return name.isNotEmpty || introduction.isNotEmpty;
    return name != (userInfo?.nickname ?? '') || introduction != (userInfo?.introduction ?? '');
  }

  bool get isValid {
    return name.trim().isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserRegisterState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.userInfo == userInfo &&
        other.name == name &&
        other.introduction == introduction &&
        other.profileImagePath == profileImagePath;
  }

  @override
  int get hashCode {
    return Object.hash(isLoading, errorMessage, userInfo, name, introduction, profileImagePath);
  }
}
