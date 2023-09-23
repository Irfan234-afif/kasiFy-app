import 'package:dio/dio.dart';
import 'package:kasir_app/app/util/constant.dart';

class SalesRepository {
  Dio get dio => _dio();

  Dio _dio() {
    const timeOut = Duration(seconds: 5);
    final baseOption = BaseOptions(
      baseUrl: urlApi,
      sendTimeout: timeOut,
      connectTimeout: timeOut,
      receiveTimeout: timeOut,
      validateStatus: (status) {
        if (status != null) {
          return status <= 404;
        }
        return false;
      },
    );

    var dio = Dio(baseOption);
    return dio;
  }

  Future<Response> getSales(String token) async {
    final Response res = await dio.get(
      'sales/get',
      options: Options(headers: _header(token)),
    );

    return res;
  }

  Future<Response> getTodaySales(String token) async {
    final Response res = await dio.get(
      'sales/get?today',
      options: Options(headers: _header(token)),
    );

    return res;
  }

  Map<String, dynamic> _header(String token) {
    return {
      'Accepts': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
