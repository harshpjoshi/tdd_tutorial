import 'dart:convert';

import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entites/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.avatar,
      required super.createdAt,
      required super.id,
      required super.name});

  const UserModel.empty()
      : this(
            id: "1",
            name: "_empty.name",
            createdAt: "_empty.createdAt",
            avatar: "_empty.avatar");

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
      : this(
            avatar: map['avatar'] as String,
            createdAt: map['createdAt'] as String,
            name: map['name'] as String,
            id: map['id'] as String);

  DataMap toMap() => {
        'id': id,
        'avatar': avatar,
        'createdAt': createdAt,
        'name': name,
      };

  String toJson() => jsonEncode(toMap());

  UserModel copyWith({
    String? avatar,
    String? createdAt,
    String? id,
    String? name,
  }) {
    return UserModel(
        avatar: avatar ?? this.avatar,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        name: name ?? this.name);
  }
}
