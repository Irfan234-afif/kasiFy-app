part of 'order_bloc.dart';

@immutable
abstract class OrderEvent {}

class OrderGetEvent extends OrderEvent {
  final String token;
  OrderGetEvent({required this.token});
}

class OrderGetTodayEvent extends OrderEvent {
  final String token;
  OrderGetTodayEvent({required this.token});
}

class OrderAddEvent extends OrderEvent {
  final String token;
  final OrderModel orderModel;
  OrderAddEvent({required this.orderModel, required this.token});
}

class OrderAddDoneEvent extends OrderEvent {
  final String token;
  final int orderId;
  final DateTime doneAt;
  OrderAddDoneEvent({required this.orderId, required this.token, required this.doneAt});
}

final class OrderEmptyEvent extends OrderEvent {}
