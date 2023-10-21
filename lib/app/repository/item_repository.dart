import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kasir_app/app/model/item_model.dart';

class ItemRepository {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<List<ItemModel>> getItem(String email) async {
    List<ItemModel> data = [];
    final getDataItem =
        await usersCollection.doc(email).collection('items').get();

    if (getDataItem.docs.isNotEmpty) {
      for (var element in getDataItem.docs) {
        data.add(ItemModel.fromJson(element.data()));
      }
    }
    print(data.length);
    return data;
  }

  Future<ItemModel> addItem(
    String email, {
    required ItemModel itemModel,
  }) async {
    final itemCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('items')
        .withConverter(
          fromFirestore: (snapshot, options) =>
              ItemModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );

    final addToFirestore = await itemCollection.add(itemModel);

    final getNewData = await addToFirestore.get().then((value) => value.data());

    return getNewData!;
  }

  Future<void> deleteItem(String email, String itemName) async {
    final itemCollection =
        usersCollection.doc(email).collection('items').withConverter(
              fromFirestore: (snapshot, options) =>
                  ItemModel.fromJson(snapshot.data()!),
              toFirestore: (value, options) => value.toJson(),
            );
    final itemWhere =
        await itemCollection.where('name', isEqualTo: itemName).get();
    for (var element in itemWhere.docs) {
      await usersCollection
          .doc(email)
          .collection('items')
          .doc(element.id)
          .delete();
    }
  }
}
