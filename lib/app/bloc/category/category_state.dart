part of 'category_bloc.dart';

@immutable
sealed class CategoryState {
  final List<CategoryModel>? categoryModel;
  const CategoryState({this.categoryModel});
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial({super.categoryModel});
}

final class CategoryLoadingState extends CategoryState {}

final class CategoryLoadedState extends CategoryState {
  const CategoryLoadedState({required super.categoryModel});
}

final class CategoryEmptyState extends CategoryState {
  const CategoryEmptyState({required super.categoryModel});
}

final class CategoryErrorState extends CategoryState {
  final String msg;

  const CategoryErrorState(this.msg);
}
