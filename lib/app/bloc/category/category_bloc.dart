// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:kasir_app/app/model/category_model.dart';
import 'package:kasir_app/app/repository/category_repository.dart';
import 'package:meta/meta.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository = CategoryRepository();

  CategoryBloc() : super(const CategoryInitial(categoryModel: [])) {
    on<CategoryGetEvent>((event, emit) async {
      try {
        emit(CategoryLoadingState());
        final res = await _categoryRepository.getCategory(event.token);
        print(res);
        // final categoryModel = categoryModelFromList(res.data['data']);
        // emit(CategoryLoadedState(categoryModel: categoryModel));
      } on DioException catch (e) {
        print('Dio error');
        print(e.response);
        emit(CategoryErrorState(e.response.toString()));
      } catch (e) {
        print(e);
      }
    });
    on<CategoryAddEvent>((event, emit) async {
      List<CategoryModel> data = List.from(state.categoryModel ?? []);
      try {
        emit(CategoryLoadingState());
        final res = await _categoryRepository.addCategory(event.token, event.categoryModel.name!);
        // print(res.statusCode);
        // // parse
        // final categoryFromRes = CategoryModel.fromJson(res.data['data']);
        // print(categoryFromRes.toJson());
        // // add data
        // final newData = data..add(categoryFromRes);
        // // emit state
        // emit(CategoryLoadedState(categoryModel: newData));
      } on DioException catch (e) {
        print('error dio');
        print(e.response);

        emit(CategoryErrorState(e.response.toString()));
      } catch (e) {
        print(e);
      }
    });
    on<CategoryDeleteEvent>((event, emit) async {
      List<CategoryModel> data = List.from(state.categoryModel ?? []);
      try {
        emit(CategoryLoadingState());
        // deleting data in server
        await _categoryRepository.deleteCategory(event.token, event.categoryModel.name.toString());
        // deleting data in model
        // final newData = data..removeWhere((element) => element.id == event.categoryModel.id);
        // // change state
        // emit(CategoryLoadedState(categoryModel: newData));
      } on DioException catch (e) {
        print('error dio');
        print(e.response);

        emit(CategoryErrorState(e.response.toString()));
      } catch (e) {
        print(e);
      }
    });
    on<CategoryEmptyEvent>((event, emit) {
      emit(const CategoryEmptyState(categoryModel: []));
    });
  }
}
