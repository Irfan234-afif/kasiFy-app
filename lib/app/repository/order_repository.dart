// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kasir_app/app/model/order_model.dart';

class OrderRepository {
  final usersFirestore = FirebaseFirestore.instance.collection('users');

  Future<List<OrderModel>> getOrder(String email) async {
    List<OrderModel> data = [];
    final getDataOrder = await usersFirestore.doc(email).collection('orders').get();
    for (var element in getDataOrder.docs) {
      data.add(OrderModel.fromJson(element.data()));
    }
    return data;
  }

  Future<List<OrderModel>> getOrderToday(String email) async {
    List<OrderModel> data = [];

    final dateNow = DateTime.now();
    final today = DateTime(dateNow.year, dateNow.month, dateNow.day);

    final getDataOrderToday = await usersFirestore
        .doc(email)
        .collection('orders')
        .where('created_at', isGreaterThanOrEqualTo: today)
        .get();

    for (var element in getDataOrderToday.docs) {
      data.add(OrderModel.fromJson(element.data()));
    }

    return data;
  }

  Future<OrderModel> addOrder(String email, OrderModel orderModel) async {
    final ordersFirestore = usersFirestore.doc(email).collection('orders').withConverter(
          fromFirestore: (snapshot, options) => OrderModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );

    final addToFirestore = await ordersFirestore.add(orderModel);

    final getNewData = addToFirestore.get().then((value) => value.data()!);
    return getNewData;
  }

  Map<String, dynamic> _headers(String token) {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
