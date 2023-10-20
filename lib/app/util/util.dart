// import 'package:intl/intl.dart';

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  var value = double.parse(data);
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  final newValue = formatter.format(value);
  return newValue;
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
  // return Platform.isIOS ? (date as Timestamp).toDate() : (date as DateTime);
  return date is Timestamp ? date.toDate() : date;
}
