import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/entities/user_entites.dart';

class UserRoleModel extends UserRoleEntities {
  UserRoleModel({required super.role});

  factory UserRoleModel.fromJson(Response res) {
    final Map<String, Roles> roleCharMap = {
      'r': Roles.read,
      'w': Roles.write,
      'c': Roles.create,
      'e': Roles.edit,
      'm': Roles.follow,
    };

    final data = res.data?.toString().toLowerCase() ?? '';
    final roles = <Roles>{};

    for (var char in data.split('')) {
      if (roleCharMap.containsKey(char)) {
        roles.add(roleCharMap[char]!);
      }
    }

    return UserRoleModel(role: roles.toList());
  }

  Map<String, dynamic> toJson() {
    return {'role': role.map((e) => e.name).toList()};
  }

  factory UserRoleModel.fromCache(String rawJson) {
    List<String> roleStrings = List<String>.from(jsonDecode(rawJson));
    List<Roles> roles = roleStrings.map((e) => Roles.values.byName(e)).toList();
    return UserRoleModel(role: roles);
  }
}
