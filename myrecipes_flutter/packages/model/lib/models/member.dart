import 'dart:convert';

class Member {
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
  String toString() => 'Member(email: $email, isAdmin: $isAdmin)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Member && o.email == email && o.isAdmin == isAdmin;
  }

  @override
  int get hashCode => email.hashCode ^ isAdmin.hashCode;
}
