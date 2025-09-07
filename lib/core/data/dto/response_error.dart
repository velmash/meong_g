class ResponseError {
  final String? code;
  final String? message;
  final String? data;

  ResponseError({this.code, this.message, this.data});

  factory ResponseError.fromJson(Map<String, dynamic> json) {
    return ResponseError(
      code: json['code'] as String?,
      message: json['message'] as String?,
      data: json['data'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'message': message, 'data': data};
  }
}
