import 'package:kasir_app/app/model/item_model.dart';
import 'package:kasir_app/app/util/constant.dart';
import 'package:dio/dio.dart';

class ItemRepository {
  ItemModel itemModel = ItemModel();

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

  Future<Response> getItem(String token) async {
    Response res = await dio.get(
      'item/get',
      options: Options(headers: _headers(token)),
    );
    // var itemModel = itemModelFromList(res.data['data']);
    // print(itemModel);
    return res;
  }

  Future<Response> addItem(
    String token, {
    required ItemModel itemModel,
  }) async {
    var data = itemModel.postToJson();
    final res = await dio.post(
      'item/store',
      options: Options(
        headers: _headers(token),
      ),
      data: data,
    );
    return res;
  }

  Future<Response> deleteItem(String token, String id) async {
    final data = {
      'item_id': id,
    };
    final Response res = await dio.post(
      'item/delete',
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
