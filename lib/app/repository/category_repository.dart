import 'package:dio/dio.dart';
import 'package:kasir_app/app/model/category_model.dart';

import '../util/constant.dart';

class CategoryRepository {
  CategoryModel categoryModel = CategoryModel();

  Dio get dio => _dio();

  Dio _dio() {
    const defaultTimeout = Duration(seconds: 5);
    final options = BaseOptions(
      baseUrl: urlApi,
      sendTimeout: defaultTimeout,
      connectTimeout: defaultTimeout,
      receiveTimeout: defaultTimeout,
      contentType: 'application/json',
      validateStatus: (status) {
        if (status == null) {
          return false;
        }
        return status <= 201;
      },
    );

    var dio = Dio(options);

    return dio;
  }

  Future<Response> getCategory(String token) async {
    final Response res = await dio.get(
      'category/get',
      options: Options(
        headers: _headers(token),
      ),
    );
    return res;
  }

  Future<Response> addCategory(String token, String nameCategory) async {
    final data = {
      'name': nameCategory,
    };
    final Response res = await dio.post(
      'category/store',
      data: data,
      options: Options(
        headers: _headers(token),
      ),
    );
    return res;
  }

  Future<Response> deleteCategory(String token, String id) async {
    final data = {
      'category_id': id,
    };
    final Response res = await dio.post(
      'category/delete',
      data: data,
      options: Options(
        headers: _headers(token),
      ),
    );
    return res;
  }

  Map<String, dynamic> _headers(String token) {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
