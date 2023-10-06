import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kasir_app/app/model/item_model.dart';

class ItemRepository {
  final usersFirestore = FirebaseFirestore.instance.collection('users');

  Future<List<ItemModel>> getItem(String email) async {
    List<ItemModel> data = [];
    final getDataItem = await usersFirestore.doc(email).collection('items').get();

    for (var element in getDataItem.docs) {
      data.add(ItemModel.fromJson(element.data()));
    }

    return data;
  }

  Future<ItemModel> addItem(
    String email, {
    required ItemModel itemModel,
  }) async {
    final itemFirestore =
        FirebaseFirestore.instance.collection('users').doc(email).collection('items').withConverter(
              fromFirestore: (snapshot, options) => ItemModel.fromJson(snapshot.data()!),
              toFirestore: (value, options) => value.toJson(),
            );

    final addToFirestore = await itemFirestore.add(itemModel);

    final getNewData = await addToFirestore.get().then((value) => value.data());

    return getNewData!;
  }

  Future<void> deleteItem(String email, String itemName) async {
    final itemFirestore = usersFirestore.doc(email).collection('items').withConverter(
          fromFirestore: (snapshot, options) => ItemModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
    final itemWhere = await itemFirestore.where('name', isEqualTo: itemName).get();
    for (var element in itemWhere.docs) {
      await usersFirestore.doc(email).collection('items').doc(element.id).delete();
    }
  }
}
