class RefreshResult {
  final String token;
  final String refreshToken;

  RefreshResult({this.token, this.refreshToken});

  factory RefreshResult.fromJson(Map<String, dynamic> json) {
    return RefreshResult(
      token: json['token'],
      refreshToken: json["refreshToken"]
    );
  }
}