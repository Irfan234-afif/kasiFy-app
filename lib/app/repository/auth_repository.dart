import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kasir_app/app/model/user_model.dart';
import 'package:kasir_app/app/util/constant.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../router/app_pages.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final UserModel userModel = UserModel();
  final dataUserDb = FirebaseFirestore.instance.collection('users').withConverter(
        fromFirestore: (snapshot, options) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
      );

  Future<void> signUp({
    required String name,
    required String shopName,
    required String email,
    required String password,
  }) async {
    final UserModel userModel = UserModel(
      email: email,
      name: name,
      shopName: shopName,
    );
    await dataUserDb.add(userModel);
    // final UserCredential credential =
    //     await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }
}
