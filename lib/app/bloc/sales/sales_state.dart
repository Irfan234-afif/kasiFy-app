part of 'sales_bloc.dart';

@immutable
sealed class SalesState {
  final List<SalesModel>? salesModel;

  const SalesState({this.salesModel});
}

final class SalesInitial extends SalesState {}

final class SalesLoadingState extends SalesState {}

final class SalesLoadedState extends SalesState {
  const SalesLoadedState({super.salesModel});
}

final class SalesEmptyState extends SalesState {
  const SalesEmptyState({super.salesModel});
}

final class SalesErrorState extends SalesState {
  final String msg;
  const SalesErrorState(this.msg);
}
