// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

List<ItemModel> itemModelFromJson(String str) =>
    List<ItemModel>.from(json.decode(str).map((x) => ItemModel.fromJson(x)));

List<ItemModel> itemModelFromList(List<dynamic> data) =>
    List<ItemModel>.from(data.map((x) => ItemModel.fromJson(x)));

String itemModelToJson(List<ItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemModel {
  final String? name;
  final int? codeProduct;
  final int? stock;
  final int? originalStock;
  final String? description;
  final String? basicPrice;
  final String? sellingPrice;
  final CategoryItem? category;

  ItemModel({
    this.name,
    this.codeProduct,
    this.stock,
    this.originalStock,
    this.description,
    this.basicPrice,
    this.sellingPrice,
    this.category,
  });

  ItemModel copyWith({
    String? name,
    int? codeProduct,
    int? stock,
    int? originalStock,
    String? description,
    String? basicPrice,
    String? sellingPrice,
    CategoryItem? category,
  }) =>
      ItemModel(
        basicPrice: basicPrice ?? this.basicPrice,
        category: category ?? this.category,
        codeProduct: codeProduct ?? this.codeProduct,
        description: description ?? this.description,
        name: name ?? this.name,
        sellingPrice: sellingPrice ?? this.sellingPrice,
        stock: stock ?? this.stock,
        originalStock: originalStock ?? this.originalStock,
      );

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        name: json["name"],
        codeProduct: json["code_product"] is int
            ? json['code_product']
            : int.parse(json['code_product']),
        stock: json['stock'] == null
            ? 0
            : json["stock"] is int
                ? json["stock"]
                : int.parse(json["stock"]),
        originalStock: json['stock'] == null
            ? 0
            : json["stock"] is int
                ? json["stock"]
                : int.parse(json["stock"]),
        description: json["description"],
        basicPrice: json["basic_price"] is String
            ? json["basic_price"]
            : json["basic_price"].toString(),
        sellingPrice: json["selling_price"] is String
            ? json["selling_price"]
            : json["selling_price"].toString(),
        category: json["category"] == null
            ? null
            : CategoryItem.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code_product": codeProduct,
        "stock": stock,
        "original_stock": originalStock,
        "description": description,
        "basic_price": basicPrice,
        "selling_price": sellingPrice,
        "category": category?.toJson(),
      };
  Map<String, dynamic> postToJson() => {
        "name": name,
        "code_product": codeProduct,
        "stock": stock,
        "description": description,
        "basic_price": double.parse(basicPrice ?? ''),
        "selling_price": double.parse(sellingPrice ?? ''),
      };
}

class CategoryItem {
  String? categoryName;

  CategoryItem({
    this.categoryName,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "category_name": categoryName,
      };
}
