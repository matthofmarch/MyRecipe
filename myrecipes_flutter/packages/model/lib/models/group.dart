import 'dart:convert';

import 'package:collection/collection.dart';

import 'member.dart';

class Group {
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
  String toString() => 'Group(name: $name, members: $members)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is Group && o.name == name && listEquals(o.members, members);
  }

  @override
  int get hashCode => name.hashCode ^ members.hashCode;
}
