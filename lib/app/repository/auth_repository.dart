import 'package:kasir_app/app/model/user_model.dart';
import 'package:kasir_app/app/util/constant.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../router/app_pages.dart';

class AuthRepository {
  UserModel userModel = UserModel();
  GetStorage box = GetStorage();

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
        return status! <= 200;
      },
    );

    var dio = Dio(options);

    return dio;
  }

  Future<void> init() async {
    Map<String, dynamic>? local = box.read('userModel');
    // if (local == null) {
    // }
    if (local != null) {
      userModel = UserModel.fromJson(local);
    }
  }

  Future<void> signUp(
      {required String name,
      required String email,
      required String shopName,
      required String password}) async {
    try {
      Response res = await dio.post(
        'register',
        data: {
          'name': name,
          'shop_name': shopName,
          'email': email,
          'password': password,
        },
        options: Options(
          headers: _headers(),
        ),
      );

      // add usermodel
      userModel = UserModel.fromJson(res.data);
      // add to local-storage
      await box.write('userModel', res.data);
      // to HomePage
      routerConfig.pushReplacementNamed(Routes.home);
      // ignore: empty_catches
    } on DioException {}
  }

  Future<Response> signIn({required String email, required String password}) async {
    // try {
    Response res = await dio.post(
      'login',
      data: {
        'email': email,
        'password': password,
      },
      options: Options(
        headers: _headers(),
      ),
    );
    // add usermodel
    userModel = UserModel.fromJson(res.data);
    // print(userModel.toJson());
    // add to local-storage
    box.write('userModel', res.data);
    // to HomePage
    routerConfig.pushReplacementNamed(Routes.home);
    return res;
    // } on DioException catch (e) {
    //   print('error dio');
    //   print(e.response);
    //   return
    // } catch (e) {
    //   print(e);
    // }
  }

  Future<void> signOut(String token) async {
    await dio.post(
      'logout',
      options: Options(
        headers: _headers()
          ..addAll(
            {
              'Authorization': 'Bearer $token',
            },
          ),
      ),
    );
    userModel = UserModel();
    box.remove('userModel');
  }

  Map<String, dynamic> _headers() {
    return {
      'Accept': 'application/json',
    };
  }
}
