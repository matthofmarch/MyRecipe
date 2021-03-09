import 'dart:convert';

import 'package:equatable/equatable.dart';

class Vote with EquatableMixin {
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
  List<Object> get props => [username, voteIsPositive];
}
