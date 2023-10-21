// import 'package:intl/intl.dart';

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../model/order_model.dart';

String simpleCurrencyFormat(String data) {
  var value = double.parse(data);
  // final formatter =
  //     NumberFormat.currency(decimalDigits: 2, locale: 'id_ID', symbol: 'Rp');
  // final newValue = formatter.format(value);
  final newValue = value / 1000;
  // newValue.round()
  return '${newValue.round()}K';
}

String currencyFormat(String data) {
  if (data.isNotEmpty) {
    var value = double.parse(data);
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    final newValue = formatter.format(value);
    return newValue;
  } else {
    return '';
  }
}

String ymdFormat(DateTime data) {
  var parse = DateFormat.yMMMMd().format(data);
  return parse;
}

String monthFormat(DateTime data) {
  var parse = DateFormat.d().format(data);
  return parse;
}

String ymdHFormat(DateTime dateTime) {
  // var ymdParse = ymdFormat(dateTime);
  var ymdParse = DateFormat.yMMMd().format(dateTime);
  var hoursparse = hoursFormat(dateTime);
  return '$ymdParse $hoursparse';
}

String hoursFormat(DateTime data) {
  final parse = DateFormat.Hm().format(data);
  return parse;
}

bool isToday(DateTime dateTime) {
  final now = DateTime.now();
  return dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day;
}

String generateCodeProduct() {
  final random = Random();
  final List<int> randomDigits = [];

  // Generate 9 random digits
  for (int i = 0; i < 9; i++) {
    randomDigits.add(random.nextInt(10)); // Generates random digits from 0 to 9
  }

  final String randomString = randomDigits.join();
  return randomString;
}

String takeLetterIdentity(String str) {
  String hasil = '';
  if (str.isNotEmpty) {
    hasil = str[0].toUpperCase();
    List<String> kataKata = str.split('');
    for (var i = 0; i < kataKata.length; i++) {
      if (i != 0) {
        if (kataKata[i] == ' ') {
          hasil += kataKata[i + 1].toUpperCase();
        }
      }
    }
    if (hasil.length < 2) {
      for (var i = 0; i < kataKata.length; i++) {
        if (kataKata[i].toUpperCase() == kataKata[i] && i != 0) {
          hasil += kataKata[i].toUpperCase();
        }
      }
    }
    if (hasil.length < 2) {
      for (var i = 0; i < kataKata.length; i++) {
        if (i == kataKata.length - 1 && hasil.length <= 2) {
          final indexHalf = kataKata.length ~/ 2;
          hasil += kataKata[indexHalf].toUpperCase();
        }
      }
    }
  }

  return hasil;
}

DateTime parseTime(dynamic date) {
  late DateTime data;
  if (date is Timestamp) {
    data = date.toDate();
  } else if (date is String) {
    data = DateTime.parse(date);
  } else {
    data = date;
  }
  // return Platform.isIOS ? (date as Timestamp).toDate() : (date as DateTime);
  return data;
}

List<OrderModel> trafficSortCalc({
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
