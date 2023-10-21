// To parse this JSON data, do
//
//     final salesModel = salesModelFromJson(jsonString);

import 'dart:convert';

import 'package:kasir_app/app/util/util.dart';

List<SalesModel> salesModelFromJson(String str) =>
    List<SalesModel>.from(json.decode(str).map((x) => SalesModel.fromJson(x)));

List<SalesModel> salesModelFromList(List data) =>
    List<SalesModel>.from(data.map((x) => SalesModel.fromJson(x)));

String salesModelToJson(List<SalesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesModel {
  String? revenue;
  String? profit;
  DateTime? createdAt;
  OrderSales? order;

  SalesModel({
    this.revenue,
    this.profit,
    this.createdAt,
    this.order,
  });

  SalesModel copyWith({
    String? revenue,
    String? profit,
    DateTime? createdAt,
    OrderSales? order,
  }) =>
      SalesModel(
        revenue: revenue ?? this.revenue,
        profit: profit ?? this.profit,
        createdAt: createdAt ?? this.createdAt,
        order: order ?? this.order,
      );

  factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        revenue: json["revenue"] is String
            ? json["revenue"]
            : json["revenue"].toString(),
        profit: json["profit"] is String
            ? json["profit"]
            : json["profit"].toString(),
        createdAt:
            json["created_at"] == null ? null : parseTime(json['created_at']),
        order:
            json["order"] == null ? null : OrderSales.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "revenue": double.parse(revenue!),
        "profit": double.parse(profit!),
        "created_at": createdAt,
        "order": order?.toJson(),
      };
}

class OrderSales {
  String? totalPrice;
  DateTime? orderAt;
  int? itemCount;

  OrderSales({
    this.totalPrice,
    this.orderAt,
    this.itemCount,
  });

  OrderSales copyWith({
    String? totalPrice,
    DateTime? orderAt,
    int? itemCount,
  }) =>
      OrderSales(
        totalPrice: totalPrice ?? this.totalPrice,
        orderAt: orderAt ?? this.orderAt,
        itemCount: itemCount ?? this.itemCount,
      );

  factory OrderSales.fromJson(Map<String, dynamic> json) => OrderSales(
        totalPrice: json["total_price"] is String
            ? json["total_price"]
            : json["total_price"].toString(),
        orderAt: json["order_at"] is DateTime
            ? json["order_at"]
            : parseTime(json["order_at"]),
        itemCount: json["item_count"],
      );

  Map<String, dynamic> toJson() => {
        "total_price": double.parse(totalPrice!),
        "order_at": orderAt?.toIso8601String(),
        "item_count": itemCount,
      };
}
