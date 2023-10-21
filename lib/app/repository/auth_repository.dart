import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kasir_app/app/model/user_model.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  UserModel userModel = UserModel();
  final userFirestore =
      FirebaseFirestore.instance.collection('users').withConverter(
            fromFirestore: (snapshot, options) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          );

  Future<void> initialize() async {
    final dataDb = await userFirestore
        .where('email', isEqualTo: firebaseAuth.currentUser?.email)
        .get();
    userModel = dataDb.docs.first.data();
  }

  Future<void> signUp({
    required String name,
    required String shopName,
    required String email,
    required String password,
  }) async {
    final DateTime dateNow = DateTime.now();
    await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    // credential.;
    String? token = await firebaseAuth.currentUser?.getIdToken();
    final UserModel parseToModel = UserModel(
      email: email,
      name: name,
      shopName: shopName,
      lastSignIn: dateNow,
      createdAt: dateNow,
      token: token,
    );

    await userFirestore.doc(email).set(parseToModel);
    userModel = parseToModel;
  }

  Future<void> signIn({required String email, required String password}) async {
    final dateNow = DateTime.now();
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    String? token = await firebaseAuth.currentUser?.getIdToken();
    final dataDb = await userFirestore.where('email', isEqualTo: email).get();
    await userFirestore.doc(dataDb.docs.first.id).update({
      'last_sign_in': dateNow,
      'token': token,
    });
    print(dataDb.docs.first.data());
    userModel = dataDb.docs.first.data();
  }

  Future<void> logout() async {
    final dataDB = await userFirestore
        .where('email', isEqualTo: firebaseAuth.currentUser?.email)
        .get();
    if (dataDB.docs.isNotEmpty) {
      await userFirestore.doc(dataDB.docs.first.id).update({
        'token': null,
      });
    }
    await firebaseAuth.signOut();
  }
}
