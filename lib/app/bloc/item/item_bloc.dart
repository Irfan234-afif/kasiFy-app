// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:kasir_app/app/model/item_model.dart';
import 'package:kasir_app/app/repository/item_repository.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository _itemRepository = ItemRepository();
  ItemBloc() : super(const ItemInitial(itemModel: [])) {
    on<ItemGetEvent>((event, emit) async {
      emit(ItemLoadingState());
      try {
        var res = await _itemRepository.getItem(event.email);
        // print(itemModel);
        emit(ItemLoadedState(itemModel: res));
      } on DioException catch (e) {
        //
        print(e.response);
        emit(ItemErrorState(e.response.toString()));
      } catch (e) {
        print('eror mboh');
        print(e);
        emit(ItemErrorState(e.toString()));
      }
    });
    on<ItemAddEvent>((event, emit) async {
      final List<ItemModel> data = List.from(state.itemModel!);
      try {
        //
        emit(ItemLoadingState());
        final res = await _itemRepository.addItem(
          event.email,
          itemModel: event.itemModel,
        );
        print(res);
        //
        // print(res.data['data']);
        final parse = res.copyWith();
        //
        final addingData = data..add(parse);
        final newData = addingData
          ..sort(
            (a, b) => b.name!.compareTo(a.name!),
          );
        // print(res);
        emit(ItemLoadedState(itemModel: newData));
      } catch (e) {
        print('error mboh');
        print(e);

        emit(ItemErrorState(e.toString()));
      }
    });
    on<ItemDeleteEvent>((event, emit) async {
      List<ItemModel> data = List.from(state.itemModel!);
      try {
        //
        emit(ItemLoadingState());
        data.removeWhere((element) => element.name == event.itemModel.name);
        await _itemRepository.deleteItem(event.email, event.itemModel.name.toString());
        // final newData = data..removeWhere((element) => element.id == event.itemModel.id);
        emit(ItemLoadedState(itemModel: data));
      } catch (e) {
        print(e);
        emit(ItemErrorState(e.toString()));
      }
    });
    on<ItemEmptyEvent>((event, emit) {
      emit(const ItemEmptyState(itemModel: []));
    });
    on<ItemDecreaseStockEvent>((event, emit) async {
      List<ItemModel> data = List.from(state.itemModel ?? []);
      try {
        emit(ItemLoadingState());
        int indexWhere = data.indexWhere((element) => element.name == event.itemModel.name);
        if (indexWhere != -1) {
          ItemModel sameItem = data[indexWhere];
          int stock = sameItem.originalStock! - event.itemModel.stock!;
          ItemModel newItemData = sameItem.copyWith(
            stock: stock,
          );
          data.removeAt(indexWhere);
          data.insert(indexWhere, newItemData);

          await _itemRepository.updateStockItem(
            event.email,
            sameItem.name!,
            stock,
          );

          emit(ItemLoadedState(itemModel: data));
        } else {
          emit(const ItemErrorState('Data error'));
        }
      } catch (e) {
        //
        print(e);
        emit(ItemErrorState(e.toString()));
      }
    });
    on<ItemUpdateStockEvent>((event, emit) async {
      List<ItemModel> data = List.from(state.itemModel ?? []);
      try {
        emit(ItemLoadingState());
        int indexWhere = data.indexWhere((element) => element.name == event.itemModel.name);
        if (indexWhere != -1) {
          ItemModel sameItem = data[indexWhere];
          int stock = event.itemModel.stock ?? 0;
          ItemModel newItemData = sameItem.copyWith(
            stock: stock,
          );
          data.removeAt(indexWhere);
          data.insert(indexWhere, newItemData);

          await _itemRepository.updateStockItem(
            event.email,
            sameItem.name!,
            stock,
          );

          emit(ItemLoadedState(itemModel: data));
        } else {
          emit(const ItemErrorState('Data error'));
        }
      } catch (e) {
        //
        print(e);
        emit(ItemErrorState(e.toString()));
      }
    });
    on<ItemEditLocalEvent>((event, emit) {
      List<ItemModel> data = List.from(state.itemModel ?? []);
      print('from event : ${event.itemModel.toJson()}');
      int indexWhere = data.indexWhere((element) => element.name == event.itemModel.name);
      if (indexWhere != -1) {
        var sameItem = data[indexWhere];
        ItemModel newData = sameItem.copyWith(
          basicPrice: event.itemModel.basicPrice,
          category: event.itemModel.category,
          codeProduct: event.itemModel.codeProduct,
          stock: event.itemModel.stock,
          originalStock: event.itemModel.originalStock,
          description: event.itemModel.description,
          name: event.itemModel.name,
          sellingPrice: event.itemModel.sellingPrice,
        );
        print('new item : ${newData.toJson()}');
        data.removeAt(indexWhere);
        final insertData = data..insert(indexWhere, newData);
        final sortingData = insertData
          ..sort(
            (a, b) => a.name!.compareTo(b.name!),
          );
        print('new Data : ${sortingData[indexWhere]}');
        emit(ItemLoadedState(itemModel: sortingData));
      }
    });
    on<ItemRestockEvent>((event, emit) {
      List<ItemModel> data = List.from(state.itemModel ?? []);
      try {
        emit(ItemLoadingState());
        int indexWhere = data.indexWhere((element) => element.name == event.itemName);
        ItemModel sameItem = data[indexWhere];
        ItemModel newItemData = sameItem.copyWith(
          stock: sameItem.originalStock,
        );

        data.removeAt(indexWhere);
        data.insert(indexWhere, newItemData);
        emit(ItemLoadedState(itemModel: data));
      } catch (e) {
        //
        print(e);
        emit(ItemErrorState(e.toString()));
      }
    });
  }
}
