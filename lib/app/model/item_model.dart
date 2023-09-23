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
  int? id;
  String? name;
  int? codeProduct;
  int? stock;
  String? description;
  String? basicPrice;
  String? sellingPrice;
  CategoryItem? category;

  ItemModel({
    this.id,
    this.name,
    this.codeProduct,
    this.stock,
    this.description,
    this.basicPrice,
    this.sellingPrice,
    this.category,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json["id"] is int ? json['id'] : int.parse(json['id']),
        name: json["name"],
        codeProduct:
            json["code_product"] is int ? json['code_product'] : int.parse(json['code_product']),
        stock: json['stock'] == null
            ? 0
            : json["stock"] is int
                ? json["stock"]
                : int.parse(json["stock"]),
        description: json["description"],
        basicPrice:
            json["basic_price"] is String ? json["basic_price"] : json["basic_price"].toString(),
        sellingPrice: json["selling_price"] is String
            ? json["selling_price"]
            : json["selling_price"].toString(),
        category: json["category"] == null ? null : CategoryItem.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code_product": codeProduct,
        "stock": stock,
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
        "category_id": category?.categoryId,
      };
}

class CategoryItem {
  int? categoryId;
  String? categoryName;

  CategoryItem({
    this.categoryId,
    this.categoryName,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
      };
}
