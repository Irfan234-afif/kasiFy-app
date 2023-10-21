import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kasir_app/app/model/sales_model.dart';

class SalesRepository {
  // final usersCollection = FirebaseFirestore.instance.collection('users');
  // final usersCollection = FirebaseFirestore.instance.collection('users').withConverter(
  //       fromFirestore: (snapshot, options) => UserModel.fromJson(snapshot.data()!),
  //       toFirestore: (value, options) => value.toJson(),
  //     );
  final usersCollection = FirebaseFirestore.instance.collection('users');
  // final salesFirestore = FirebaseFirestore.instance.collection('users').withConverter(
  //       fromFirestore: (snapshot, options) => SalesModel.fromJson(snapshot.data()!),
  //       toFirestore: (sales, options) => sales.toJson(),
  //     );

  Future<List<SalesModel>?> getSales(String email) async {
    // final getData = await salesFirestore.doc(uid).get();
    // return getData.data();
    List<SalesModel> data = [];
    if (email.isNotEmpty) {
      final getSalesData =
          await usersCollection.doc(email).collection('sales').get();
      for (var element in getSalesData.docs) {
        data.add(SalesModel.fromJson(element.data()));
      }
    }
    return data;
  }

  Future<List<SalesModel>> getTodaySales(String email) async {
    List<SalesModel> data = [];

    final dateNow = DateTime.now();
    final today = DateTime(dateNow.year, dateNow.month, dateNow.day);
    final getSalesDataToday = await usersCollection
        .doc(email)
        .collection('sales')
        .where(
          'created_at',
          isGreaterThan: today,
        )
        .get();
    for (var element in getSalesDataToday.docs) {
      data.add(SalesModel.fromJson(element.data()));
    }
    return data;
  }

  Future<SalesModel?> addSales({
    required String email,
    required SalesModel data,
  }) async {
    final salesCollection =
        usersCollection.doc(email).collection('sales').withConverter(
              fromFirestore: (snapshot, options) =>
                  SalesModel.fromJson(snapshot.data()!),
              toFirestore: (value, options) => value.toJson(),
            );
    final addToFirestore = await salesCollection.add(data);
    final getNewData = await addToFirestore.get().then((value) => value.data());

    return getNewData;
  }

  Map<String, dynamic> _header(String token) {
    return {
      'Accepts': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
