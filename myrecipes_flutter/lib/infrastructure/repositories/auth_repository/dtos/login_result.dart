class LoginResult{
  final String token;
  final String refreshToken;
  final DateTime expiration;

  LoginResult({this.token, this.refreshToken, this.expiration});

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      token: json['token'],
      refreshToken: json["refreshToken"],
      expiration: DateTime.parse(json['expiration']),
    );
  }
}