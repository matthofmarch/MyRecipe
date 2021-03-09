import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'member.dart';

class Group with EquatableMixin {
  final String name;
  final List<Member> members;

  Group({
    this.name,
    this.members,
  });

  Group copyWith({
    String name,
    List<Member> members,
  }) {
    return Group(
      name: name ?? this.name,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'members': members?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Group(
      name: map['name'],
      members: List<Member>.from(map['members']?.map((x) => Member.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source));

  @override
  List<Object> get props => [name, members];
}
