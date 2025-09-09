import 'package:meong_g/core/data/dto/response_error.dart';
import 'package:meong_g/core/domain/entities/user_info.dart';
import 'package:meong_g/core/domain/entities/auth_type.dart';

class UserInfoDto {
  final String? result;
  final ResponseData? data;
  final ResponseError? error;

  UserInfoDto({this.result, this.data, this.error});

  factory UserInfoDto.fromJson(Map<String, dynamic> json) {
    return UserInfoDto(
      result: json['result'] as String?,
      data: json['data'] != null ? ResponseData.fromJson(json['data'] as Map<String, dynamic>) : null,
      error: json['error'] != null ? ResponseError.fromJson(json['error'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'result': result, 'data': data?.toJson(), 'error': error?.toJson()};
  }

  /// ResponseData → UserInfo 변환
  UserInfo? toUserInfo() {
    if (data == null) return null;
    return UserInfo(
      nickname: data!.nickname,
      introduction: data!.introduction,
      profileImageFileName: data!.profileImageFileName,
      authType: AuthType.fromString(data!.authType),
    );
  }
}

class ResponseData {
  final String? nickname;
  final String? introduction;
  final String? profileImageFileName;
  final String? authType;

  ResponseData({this.nickname, this.introduction, this.profileImageFileName, this.authType});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      nickname: json['nickname'] as String?,
      introduction: json['introduction'] as String?,
      profileImageFileName: json['profileImageFileName'] as String?,
      authType: json['authType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'introduction': introduction,
      'profileImageFileName': profileImageFileName,
      'authType': authType,
    };
  }
}
