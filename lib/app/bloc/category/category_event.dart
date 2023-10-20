part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

final class CategoryGetEvent extends CategoryEvent {
  final String email;

  CategoryGetEvent(this.email);
}

final class CategoryAddEvent extends CategoryEvent {
  final String email;
  final CategoryModel categoryModel;

  CategoryAddEvent(this.email, {required this.categoryModel});
}

final class CategoryDeleteEvent extends CategoryEvent {
  final String email;
  final CategoryModel categoryModel;

  CategoryDeleteEvent(this.email, {required this.categoryModel});
}

final class CategoryEmptyEvent extends CategoryEvent {}
