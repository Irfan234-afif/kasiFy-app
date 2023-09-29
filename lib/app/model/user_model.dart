// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? name;
  String? shopName;
  String? email;
  DateTime? createdAt;
  DateTime? lastSignIn;

  UserModel({
    this.name,
    this.shopName,
    this.email,
    this.createdAt,
    this.lastSignIn,
  });

  UserModel copyWith({
    String? name,
    String? shopName,
    String? email,
    DateTime? createdAt,
    DateTime? lastSignIn,
  }) =>
      UserModel(
        name: name ?? this.name,
        shopName: shopName ?? this.shopName,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        lastSignIn: lastSignIn ?? this.lastSignIn,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        shopName: json["shop_name"],
        email: json["email"],
        createdAt: json["created_at"],
        lastSignIn: json["last_sign_in"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "shop_name": shopName,
        "email": email,
        "created_at": createdAt,
        "lastSignIn": lastSignIn,
      };
}
