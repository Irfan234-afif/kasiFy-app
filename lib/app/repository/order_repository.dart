// ignore_for_file: avoid_print

import 'package:kasir_app/app/model/order_model.dart';
import 'package:kasir_app/app/util/constant.dart';
import 'package:dio/dio.dart';

class OrderRepository {
  Dio get dio => _dio();

  Dio _dio() {
    const timeOut = Duration(seconds: 5);
    final baseOption = BaseOptions(
      baseUrl: urlApi,
      sendTimeout: timeOut,
      connectTimeout: timeOut,
      receiveTimeout: timeOut,
      validateStatus: (status) {
        // if (status == null) {
        //   return false;
        // }
        // return status <= 200;
        return true;
      },
    );

    var dio = Dio(baseOption);
    return dio;
  }

  Future<Response> getOrder(String token) async {
    Response res = await dio.get(
      'order/get',
      options: Options(headers: _headers(token)),
    );
    return res;
  }

  Future<List<OrderModel>?> getOrderProcces(String token) async {
    try {
      Response res = await dio.get(
        'order/get?procces',
        options: Options(headers: _headers(token)),
      );
      var orderModel = orderModelFromList(res.data['data']);
      return orderModel;
    } on DioException catch (e) {
      print(e.response);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response> getOrderToday(String token) async {
    Response res = await dio.get(
      'order/get?today',
      options: Options(headers: _headers(token)),
    );
    print(res.statusCode);

    return res;
  }

  Future<Response> addOrder(String token, OrderModel orderModel) async {
    Response res = await dio.post(
      'order/store',
      options: Options(
        headers: _headers(token),
      ),
      data: orderModel.toJsonPost(),
    );
    print(res.statusMessage);
    print(res.data);

    return res;
  }

  Map<String, dynamic> _headers(String token) {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
