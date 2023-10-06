part of 'temp_order_bloc.dart';

@immutable
abstract class TempOrderEvent {}

class TempOrderAddEvent extends TempOrderEvent {
  final ItemOrder item;

  TempOrderAddEvent({required this.item});
}

class TempOrderUpdateEvent extends TempOrderEvent {
  final OrderModel orderModel;

  TempOrderUpdateEvent({required this.orderModel});
}

class TempOrderDeleteEvent extends TempOrderEvent {
  final String name;
  TempOrderDeleteEvent({required this.name});
}

class TempOrderEmptyEvent extends TempOrderEvent {}
