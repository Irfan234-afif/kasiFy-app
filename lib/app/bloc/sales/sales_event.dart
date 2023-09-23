part of 'sales_bloc.dart';

@immutable
sealed class SalesEvent {}

final class SalesGetTodayEvent extends SalesEvent {
  final String token;
  SalesGetTodayEvent(this.token);
}

final class SalesGetEvent extends SalesEvent {
  final String token;
  SalesGetEvent(this.token);
}

// final class SalesAddEvent extends SalesEvent {
//   final String token;
//   final SalesModel salesModel;
//   SalesAddEvent(this.token, {required this.salesModel});
// }
