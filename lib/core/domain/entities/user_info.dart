class UserInfo {
  final String? nickname;
  final String? introduction;
  final String? profileImageFileName;
  final String? authType;

  UserInfo({
    required this.nickname,
    required this.introduction,
    required this.profileImageFileName,
    required this.authType,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      nickname: json['nickname'] as String?,
      introduction: json['introduction'] as String?,
      profileImageFileName: json['profileImageFileName'] as String?,
      authType: json['authType'] as String?,
    );
  }
}
