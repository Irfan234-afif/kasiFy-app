// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:kasir_app/app/util/util.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? name;
  String? shopName;
  String? email;
  String? token;
  DateTime? createdAt;
  DateTime? lastSignIn;

  UserModel({
    this.name,
    this.shopName,
    this.email,
    this.token,
    this.createdAt,
    this.lastSignIn,
  });

  UserModel copyWith({
    String? name,
    String? shopName,
    String? email,
    String? token,
    DateTime? createdAt,
    DateTime? lastSignIn,
  }) =>
      UserModel(
        name: name ?? this.name,
        shopName: shopName ?? this.shopName,
        email: email ?? this.email,
        token: token ?? this.token,
        createdAt: createdAt ?? this.createdAt,
        lastSignIn: lastSignIn ?? this.lastSignIn,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        shopName: json["shop_name"],
        email: json["email"],
        token: json["token"],
        createdAt: parseTime(json["created_at"]),
        lastSignIn: parseTime(json["last_sign_in"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "shop_name": shopName,
        "email": email,
        "token": token,
        "created_at": createdAt,
        "last_sign_in": lastSignIn,
      };
}
