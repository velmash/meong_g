enum AuthType {
  kakao('KAKAO'),
  naver('NAVER');

  const AuthType(this.value);
  
  final String value;

  String get displayText {
    switch (this) {
      case AuthType.kakao:
        return '카카오로 로그인';
      case AuthType.naver:
        return '네이버로 로그인';
    }
  }

  static AuthType? fromString(String? value) {
    if (value == null) return null;
    
    for (AuthType type in AuthType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return null;
  }
}