// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kasir_app/app/model/order_model.dart';

import '../model/sales_model.dart';

class OrderRepository {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<List<OrderModel>> getOrder(String email) async {
    List<OrderModel> data = [];
    final getDataOrder =
        await usersCollection.doc(email).collection('orders').get();
    for (var element in getDataOrder.docs) {
      data.add(OrderModel.fromJson(element.data()));
    }
    return data;
  }

  Future<List<OrderModel>> getOrderToday(String email) async {
    List<OrderModel> data = [];

    final dateNow = DateTime.now();
    final today = DateTime(dateNow.year, dateNow.month, dateNow.day);

    final getDataOrderToday = await usersCollection
        .doc(email)
        .collection('orders')
        .where('created_at', isGreaterThanOrEqualTo: today)
        .get();

    for (var element in getDataOrderToday.docs) {
      data.add(OrderModel.fromJson(element.data()));
    }

    return data;
  }

  Future<OrderModel?> addOrder(String email, OrderModel orderModel) async {
    final ordersFirestore =
        usersCollection.doc(email).collection('orders').withConverter(
              fromFirestore: (snapshot, options) =>
                  OrderModel.fromJson(snapshot.data()!),
              toFirestore: (value, options) => value.toJsonPost(),
            );

    final addToFirestore = await ordersFirestore.add(orderModel);

    final getNewData = await addToFirestore.get().then((value) => value.data());
    await _addToSales(email, orderModel);
    return getNewData;
  }

  Future<void> _addToSales(String email, OrderModel data) async {
    double revenue = double.parse(data.totalPrice!);
    double profit = 0;

    // find profit
    // with loop item in orderModel
    for (ItemOrder item in data.items!) {
      // parse String to double
      double parseSellingPrice = double.parse(item.sellingPrice!);
      double parseBasicPrice = double.parse(item.basicPrice!);
      profit += parseSellingPrice - parseBasicPrice;
    }

    OrderSales orderSales = OrderSales(
      itemCount: data.items?.length,
      orderAt: data.orderAt,
      totalPrice: data.totalPrice,
    );
    SalesModel salesModel = SalesModel(
      createdAt: data.orderAt,
      order: orderSales,
      profit: profit.toString(),
      revenue: revenue.toString(),
    );

    final salesCollection =
        usersCollection.doc(email).collection('sales').withConverter(
              fromFirestore: (snapshot, options) =>
                  SalesModel.fromJson(snapshot.data()!),
              toFirestore: (value, options) => value.toJson(),
            );
    await salesCollection.add(salesModel);
    // final getNewData = await addToFirestore.get().then((value) => value.data());

    // return getNewData;

    // context.read<SalesBloc>().add(
    //       SalesAddEvent(
    //         email: email,
    //         data: salesModel,
    //       ),
    //     );
  }
}
