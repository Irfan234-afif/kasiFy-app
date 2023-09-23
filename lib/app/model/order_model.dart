// To parse this JSON data, do

// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

List<OrderModel> orderModelFromList(List data) =>
    List<OrderModel>.from(data.map((x) => OrderModel.fromJson(x)));
String orderModelToJson(List<OrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListOrder {
  List<OrderModel>? listOrder;
  ListOrder({this.listOrder});

  ListOrder copyWith({
    List<OrderModel>? listOrder,
  }) =>
      ListOrder(
        listOrder: listOrder ?? this.listOrder,
      );
}

class OrderModel {
  int? id;
  String? name;
  String? totalPrice;
  int? userId;
  DateTime? orderAt;
  List<ItemOrder>? items;

  OrderModel({
    this.id,
    this.userId,
    this.name,
    this.totalPrice,
    this.orderAt,
    this.items,
  });

  OrderModel copyWith({
    int? id,
    int? userId,
    String? name,
    String? totalPrice,
    DateTime? doneAt,
    DateTime? orderAt,
    List<ItemOrder>? items,
  }) =>
      OrderModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        totalPrice: totalPrice ?? this.totalPrice,
        orderAt: orderAt ?? this.orderAt,
        items: items ?? this.items,
      );

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        totalPrice: json["total_price"],
        orderAt: json["order_at"] == null ? null : DateTime.parse(json["order_at"]),
        items: json["items"] == null
            ? []
            : List<ItemOrder>.from(json["items"]!.map((x) => ItemOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "order_at": orderAt?.toIso8601String(),
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
  Map<String, dynamic> toJsonPost() => {
        "user_id": userId,
        "name": name,
        "total_price": totalPrice,
        "order_at": orderAt?.toIso8601String(),
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class ItemOrder {
  int? id;
  String? name;
  String? detail;
  int? quantity;
  String? basicPrice;
  String? sellingPrice;

  ItemOrder({
    this.id,
    this.name,
    this.detail,
    this.quantity,
    this.basicPrice,
    this.sellingPrice,
  });

  ItemOrder copyWith({
    int? id,
    String? name,
    String? detail,
    int? quantity,
    String? basicPrice,
    String? sellingPrice,
  }) =>
      ItemOrder(
        id: id ?? this.id,
        name: name ?? this.name,
        detail: detail ?? this.detail,
        quantity: quantity ?? this.quantity,
        basicPrice: basicPrice ?? this.basicPrice,
        sellingPrice: sellingPrice ?? this.basicPrice,
      );

  factory ItemOrder.fromJson(Map<String, dynamic> json) => ItemOrder(
        id: json["id"],
        name: json["name"],
        detail: json["detail"],
        quantity: json["quantity"],
        basicPrice: json["basic_price"],
        sellingPrice: json["selling_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "detail": detail,
        "quantity": quantity,
        "basic_price": basicPrice,
        "selling_price": sellingPrice,
      };
}
