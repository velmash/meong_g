class KakaoUser {
  final String id;
  final String? nickname;
  final String? profileImageUrl;
  final String? email;

  KakaoUser({
    required this.id,
    this.nickname,
    this.profileImageUrl,
    this.email,
  });

  factory KakaoUser.fromJson(Map<String, dynamic> json) {
    return KakaoUser(
      id: json['id'] as String,
      nickname: json['nickname'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
      'email': email,
    };
  }
}