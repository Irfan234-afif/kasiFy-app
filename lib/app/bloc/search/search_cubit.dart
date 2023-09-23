// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:kasir_app/app/model/item_model.dart';
import 'package:kasir_app/app/model/order_model.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchInitial(data: []));

  void fetchItem<T>(dynamic data) {
    emit(SearchInitial<T>(data: data as T));
  }

  void updateItem<T>(T data) {
    emit(SearchComplete<T>(result: data, data: data));
  }

  void performSearch<T>(String query) {
    if (query == '') {
      emit(SearchOff(data: state.data));
    } else {
      if (T == List<ItemModel>) {
        print(state.data);
        List<ItemModel> result = [];
        final data = state.data as List<ItemModel>?;
        if (data?.isNotEmpty ?? false) {
          for (var element in data!) {
            if (element.name!.toUpperCase().startsWith(query.toUpperCase())) {
              result.add(element);
            }
          }
        }
        if (result.isNotEmpty) {
          emit(SearchComplete<List<ItemModel>>(result: result, data: data));
        } else {
          emit(SearchEmpty(data: data));
        }
      } else if (T == List<OrderModel>) {
        List<OrderModel> result = [];
        final List<OrderModel> data = List.from(state.data as List<OrderModel>);
        for (var element in data) {
          if (element.name!.toUpperCase().startsWith(query.toUpperCase())) {
            result.add(element);
          }
        }
        if (result.isNotEmpty) {
          emit(SearchComplete<List<OrderModel>>(result: result, data: data));
        } else {
          emit(SearchEmpty(data: data));
        }
      }
    }
  }

  void filter<T>(String category) {
    if (T == List<ItemModel>) {
      List<ItemModel> result = [];
      final data = state.data as List<ItemModel>;
      if (data.isNotEmpty) {
        for (var element in data) {
          if (element.category?.categoryName == category) {
            result.add(element);
          }
        }
      }
      if (result.isNotEmpty) {
        emit(SearchComplete(result: result, data: data));
      } else {
        emit(SearchEmpty(data: data));
      }
    }
  }

  void searchOff() {
    emit(SearchOff(data: state.data));
  }
}
