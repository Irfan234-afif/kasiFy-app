part of 'order_bloc.dart';

@immutable
abstract class OrderEvent {}

class OrderGetEvent extends OrderEvent {
  final String email;
  OrderGetEvent({required this.email});
}

class OrderGetTodayEvent extends OrderEvent {
  final String email;
  OrderGetTodayEvent({required this.email});
}

class OrderAddEvent extends OrderEvent {
  final String email;
  final OrderModel orderModel;
  OrderAddEvent({required this.orderModel, required this.email});
}

class OrderAddDoneEvent extends OrderEvent {
  final String email;
  final int orderId;
  final DateTime doneAt;
  OrderAddDoneEvent({required this.orderId, required this.email, required this.doneAt});
}

final class OrderEmptyEvent extends OrderEvent {}
