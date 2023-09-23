// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  Meta? meta;
  String? token;

  UserModel({
    this.meta,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "token": token,
      };
}

class Meta {
  int? id;
  String? name;
  String? shopName;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;

  Meta({
    this.id,
    this.name,
    this.shopName,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        id: json["id"],
        name: json["name"],
        shopName: json["shop_name"],
        email: json["email"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "shop_name": shopName,
        "email": email,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
