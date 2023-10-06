import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kasir_app/app/model/category_model.dart';

class CategoryRepository {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<List<CategoryModel>> getCategory(String email) async {
    List<CategoryModel> data = [];

    final getDataCategory = await usersCollection.doc(email).collection('categories').get();

    for (var element in getDataCategory.docs) {
      data.add(CategoryModel.fromJson(element.data()));
    }

    return data;
  }

  Future<CategoryModel?> addCategory(String email, String nameCategory) async {
    final parseToModel = CategoryModel(
      createdAt: DateTime.now(),
      name: nameCategory,
      updatedAt: DateTime.now(),
    );

    final categoryFirestore = usersCollection.doc(email).collection('categories').withConverter(
          fromFirestore: (snapshot, options) => CategoryModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );

    final addToFirestore = await categoryFirestore.add(parseToModel);

    final getNewData = await addToFirestore.get().then((value) => value.data());

    return getNewData;
  }

  Future<void> deleteCategory(String email, String nameCategory) async {
    final categoryFirestore = usersCollection.doc(email).collection('categories').withConverter(
          fromFirestore: (snapshot, options) => CategoryModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
    final whereData = await categoryFirestore.where('name', isEqualTo: nameCategory).get();

    for (var element in whereData.docs) {
      await usersCollection.doc(email).collection('categories').doc(element.id).delete();
    }
  }

  Map<String, dynamic> _headers(String token) {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
