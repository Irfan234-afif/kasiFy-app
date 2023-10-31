import 'package:kasir_app/app/util/util.dart';

import '../model/item_model.dart';
import '../model/order_model.dart';
import '../model/sales_model.dart';

List<OrderModel> trafficOrderCalc({
  required List<OrderModel> dataOrder,
  required int indexFilter,
}) {
  List<OrderModel> sortedData = [];

  for (var element in dataOrder) {
    final dateNow = DateTime.now();
    switch (indexFilter) {
      case 0:
        sortedData.add(element);

        break;
      case 1:
        if (element.orderAt!.year == dateNow.year) {
          sortedData.add(element);
        }
        break;
      case 2:
        if (element.orderAt!.year == dateNow.year &&
            element.orderAt!.month == dateNow.month) {
          sortedData.add(element);
        }
        break;
      case 3:
        if (element.orderAt!.year == dateNow.year &&
            element.orderAt!.month == dateNow.month &&
            element.orderAt!.day == dateNow.day) {
          sortedData.add(element);
        }
        break;
      default:
    }
  }

  return sortedData;
}

List<OrderModel> trafficSortCalc48Hours({
  required List<OrderModel> dataOrder,
}) {
  final dateNow = DateTime.now();
  const maxDuration = Duration(hours: 48);

  List<OrderModel> last48HoursData = dataOrder.where((element) {
    Duration difference = dateNow.difference(element.orderAt!);
    return difference <= maxDuration;
  }).toList();

  // for (var element in dataOrder) {

  //   if (element.orderAt.is) {
  //     last48HoursData.add(element);
  //   }
  // }

  return last48HoursData;
}

List<ItemOrder> trafficItemRankCalc({
  required List<OrderModel> dataSorted,
}) {
  final List<ItemOrder> newData = [];
  for (var dataOrder in dataSorted) {
    for (var item in dataOrder.items!) {
      int indexCheckItem =
          newData.indexWhere((newItem) => newItem.name == item.name);
      if (indexCheckItem == -1) {
        // print('oi');
        newData.add(item);
      } else {
        ItemOrder sameItem = newData[indexCheckItem];
        var newItemData = sameItem.copyWith(
          quantity: sameItem.quantity! + item.quantity!,
          sellingPrice: sameItem.sellingPrice! + item.sellingPrice!,
          basicPrice: sameItem.basicPrice! + item.basicPrice!,
        );
        newData.removeAt(indexCheckItem);
        newData.insert(indexCheckItem, newItemData);
      }
    }
  }
  // sort data item berdasarkan quantityy
  newData.sort(
    (a, b) => b.quantity!.compareTo(a.quantity!),
  );
  return newData;
}

List<ItemModel>? listItemLowStock({
  required List<ItemModel>? data,
}) {
  final List<ItemModel>? newData = data
    ?..sort(
      (a, b) => a.stock?.compareTo(b.stock ?? 0) ?? 0,
    );
  // sort data item berdasarkan quantityy
  // newData?.sort(
  //   (a, b) => (b.stock?.compareTo(a.stock as num)) ?? 0,
  // );
  return newData;
}

List<SalesModel> sortSalesToday(List<SalesModel> data) {
  return data
      .where((element) =>
          ymdFormat(element.createdAt!) == ymdFormat(DateTime.now()))
      .toList();
}

List<SalesModel> sortEconomyData({
  required List<SalesModel> data,
  required int indexFilter,
}) {
  List<SalesModel> sortedData = [];

  // sorting data by indexFilter
  /// 0 => Year
  /// 1 => Month
  /// 2 => Day
  for (var element in data) {
    final dateNow = DateTime.now();
    switch (indexFilter) {
      case 0:
        sortedData.add(element);
        break;
      case 1:
        if (element.createdAt!.year == dateNow.year) {
          sortedData.add(element);
        }
        break;
      case 2:
        if (element.createdAt!.year == dateNow.year &&
            element.createdAt!.month == dateNow.month) {
          sortedData.add(element);
        }
        break;
      case 3:
        if (element.createdAt!.year == dateNow.year &&
            element.createdAt!.month == dateNow.month &&
            element.createdAt!.day == dateNow.day) {
          sortedData.add(element);
        }
        break;
      default:
    }
  }

  return sortedData;
}

List<SalesModel> sortEconomy48Hours({
  required List<SalesModel> data,
}) {
  final dateNow = DateTime.now();
  const maxDuration = Duration(hours: 48);

  List<SalesModel> sortedData = data.where((element) {
    Duration difference = dateNow.difference(element.createdAt!);
    return difference <= maxDuration;
  }).toList();

  return sortedData;
}

List<SalesModel> trafficEconomyCalc({
  required List<SalesModel> data,
  required String Function(DateTime) metode,
}) {
  List<SalesModel> dataChart = [];

  /// Sort data chart
  for (var element in data) {
    final parse = metode(element.createdAt!);

    int indexCheck = dataChart.indexWhere((newRank) {
      return metode(newRank.createdAt!) == parse;
    });
    if (indexCheck == -1) {
      dataChart.add(element);
    } else {
      SalesModel sameData = dataChart[indexCheck];
      final parseProfit =
          double.parse(sameData.profit!) + double.parse(element.profit!);

      final parseRevenue =
          double.parse(sameData.revenue!) + double.parse(element.revenue!);
      var copyData = sameData.copyWith(
        revenue: parseRevenue.toString(),
        profit: parseProfit.toString(),
      );
      dataChart.removeAt(indexCheck);
      dataChart.insert(indexCheck, copyData);
    }
  }
  dataChart.sort(
    (a, b) => a.createdAt!.compareTo(b.createdAt!),
  );

  return dataChart;
}
