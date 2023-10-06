import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kasir_app/app/model/sales_model.dart';
import 'package:kasir_app/app/model/user_model.dart';

class SalesRepository {
  // final usersFirestore = FirebaseFirestore.instance.collection('users');
  // final usersFirestore = FirebaseFirestore.instance.collection('users').withConverter(
  //       fromFirestore: (snapshot, options) => UserModel.fromJson(snapshot.data()!),
  //       toFirestore: (value, options) => value.toJson(),
  //     );
  final usersFirestore = FirebaseFirestore.instance.collection('users');
  // final salesFirestore = FirebaseFirestore.instance.collection('users').withConverter(
  //       fromFirestore: (snapshot, options) => SalesModel.fromJson(snapshot.data()!),
  //       toFirestore: (sales, options) => sales.toJson(),
  //     );

  Future<List<SalesModel>?> getSales(String email) async {
    // final getData = await salesFirestore.doc(uid).get();
    // return getData.data();
    List<SalesModel> data = [];
    if (email.isNotEmpty) {
      final getSalesData = await usersFirestore.doc(email).collection('sales').get();
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
    final getSalesDataToday = await usersFirestore
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

  Map<String, dynamic> _header(String token) {
    return {
      'Accepts': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
