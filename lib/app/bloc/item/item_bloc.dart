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
    on<ItemInitialEvent>((event, emit) async {
      emit(ItemLoadingState());
      try {
        var res = await _itemRepository.getItem(event.token);
        var itemModel = itemModelFromList(res.data['data'] ?? [])
          ..sort(
            (a, b) {
              return a.category!.categoryName!.compareTo(b.category!.categoryName!);
            },
          );
        print(itemModel);
        emit(ItemLoadedState(itemModel: itemModel));
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
          event.token,
          itemModel: event.itemModel,
        );
        //
        print(res.data['data']);
        final parse = ItemModel.fromJson(res.data['data']);
        //
        final addingData = data..add(parse);
        final newData = addingData
          ..sort(
            (a, b) => b.name!.compareTo(a.name!),
          );
        // print(res);
        emit(ItemLoadedState(itemModel: newData));
      } on DioException catch (e) {
        //
        print('error dio');
        print(e.response);
        emit(ItemErrorState(e.response.toString()));
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
        await _itemRepository.deleteItem(event.token, event.itemModel.id.toString());
        final newData = data..removeWhere((element) => element.id == event.itemModel.id);
        emit(ItemLoadedState(itemModel: newData));
      } on DioException catch (e) {
        //
        print('error dio');
        emit(ItemErrorState(e.response.toString()));
      } catch (e) {
        print(e);
        emit(ItemErrorState(e.toString()));
      }
    });
    on<ItemEmptyEvent>((event, emit) {
      emit(const ItemEmptyState(itemModel: []));
    });
    on<ItemEditLocalEvent>((event, emit) {
      List<ItemModel> data = List.from(state.itemModel ?? []);
      int indexWhere = data.indexWhere((element) => element.id == event.itemModel.id);
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
        data.removeAt(indexWhere);
        final insertData = data..insert(indexWhere, newData);
        final sortingData = insertData
          ..sort(
            (a, b) => a.name!.compareTo(b.name!),
          );
        emit(ItemLoadedState(itemModel: sortingData));
      }
    });
  }
}
