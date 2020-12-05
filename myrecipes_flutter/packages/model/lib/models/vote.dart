import 'dart:convert';

class Vote {
  final String username;
  final bool voteIsPositive;
  Vote({
    this.username,
    this.voteIsPositive,
  });

  Vote copyWith({
    String username,
    bool voteIsPositive,
  }) {
    return Vote(
      username: username ?? this.username,
      voteIsPositive: voteIsPositive ?? this.voteIsPositive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'voteIsPositive': voteIsPositive,
    };
  }

  factory Vote.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Vote(
      username: map['username'],
      voteIsPositive: map['vote'] == "Approved",
    );
  }

  String toJson() => json.encode(toMap());

  factory Vote.fromJson(String source) => Vote.fromMap(json.decode(source));

  @override
  String toString() =>
      'Vote(username: $username, voteIsPositive: $voteIsPositive)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Vote &&
        o.username == username &&
        o.voteIsPositive == voteIsPositive;
  }

  @override
  int get hashCode => username.hashCode ^ voteIsPositive.hashCode;
}
