import 'auth_type.dart';

class UserInfo {
  final String? nickname;
  final String? introduction;
  final String? profileImageFileName;
  final AuthType? authType;

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
      authType: AuthType.fromString(json['authType'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'nickname': nickname,
      'introduction': introduction,
    };

    if (profileImageFileName != null && profileImageFileName!.isNotEmpty) {
      json['imageFile'] = profileImageFileName;
    }

    return json;
  }
}
