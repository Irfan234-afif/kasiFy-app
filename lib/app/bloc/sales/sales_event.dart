part of 'sales_bloc.dart';

@immutable
sealed class SalesEvent {}

final class SalesGetTodayEvent extends SalesEvent {
  final String email;
  SalesGetTodayEvent(this.email);
}

final class SalesGetEvent extends SalesEvent {
  final String email;
  SalesGetEvent(this.email);
}

final class SalesAddEvent extends SalesEvent {
  final String email;
  final SalesModel data;
  SalesAddEvent({required this.email, required this.data});
}

// final class SalesAddEvent extends SalesEvent {
//   final String token;
//   final SalesModel salesModel;
//   SalesAddEvent(this.token, {required this.salesModel});
// }
