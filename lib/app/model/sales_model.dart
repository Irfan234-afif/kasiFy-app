// To parse this JSON data, do
//
//     final salesModel = salesModelFromJson(jsonString);

import 'dart:convert';

List<SalesModel> salesModelFromJson(String str) =>
    List<SalesModel>.from(json.decode(str).map((x) => SalesModel.fromJson(x)));

List<SalesModel> salesModelFromList(List data) =>
    List<SalesModel>.from(data.map((x) => SalesModel.fromJson(x)));

String salesModelToJson(List<SalesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesModel {
  int? orderCount;
  String? revenue;
  String? profit;
  DateTime? createdAt;
  OrderSales? order;

  SalesModel({
    this.orderCount,
    this.revenue,
    this.profit,
    this.createdAt,
    this.order,
  });

  SalesModel copyWith({
    int? orderCount,
    String? revenue,
    String? profit,
    DateTime? createdAt,
    OrderSales? order,
  }) =>
      SalesModel(
        orderCount: orderCount ?? this.orderCount,
        revenue: revenue ?? this.revenue,
        profit: profit ?? this.profit,
        createdAt: createdAt ?? this.createdAt,
        order: order ?? this.order,
      );

  factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        orderCount: json["order_count"],
        revenue: json["revenue"],
        profit: json["profit"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json['created_at']).toLocal(),
        order: json["order"] == null ? null : OrderSales.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "order_count": orderCount,
        "revenue": revenue,
        "profit": profit,
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
        totalPrice: json["total_price"],
        orderAt: json["order_at"] == null ? null : DateTime.parse(json["order_at"]),
        itemCount: json["item_count"],
      );

  Map<String, dynamic> toJson() => {
        "total_price": totalPrice,
        "order_at": orderAt?.toIso8601String(),
        "item_count": itemCount,
      };
}
