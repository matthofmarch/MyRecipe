import 'dart:convert';

import 'package:equatable/equatable.dart';

class Member with EquatableMixin {
  final String email;
  final bool isAdmin;

  Member({
    this.email,
    this.isAdmin,
  });

  Member copyWith({
    String email,
    bool isAdmin,
  }) {
    return Member(
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'isAdmin': isAdmin,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Member(
      email: map['email'],
      isAdmin: map['isAdmin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) => Member.fromMap(json.decode(source));

  @override
  // TODO: implement props
  List<Object> get props => [email, isAdmin];
}
