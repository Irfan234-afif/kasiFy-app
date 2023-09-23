part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

final class CategoryGetEvent extends CategoryEvent {
  final String token;

  CategoryGetEvent(this.token);
}

final class CategoryAddEvent extends CategoryEvent {
  final String token;
  final CategoryModel categoryModel;

  CategoryAddEvent(this.token, {required this.categoryModel});
}

final class CategoryDeleteEvent extends CategoryEvent {
  final String token;
  final CategoryModel categoryModel;

  CategoryDeleteEvent(this.token, {required this.categoryModel});
}

final class CategoryEmptyEvent extends CategoryEvent {}
