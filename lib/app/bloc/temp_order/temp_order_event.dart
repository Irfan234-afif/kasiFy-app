part of 'temp_order_bloc.dart';

@immutable
abstract class TempOrderEvent {}

class TempOrderAddEvent extends TempOrderEvent {
  final ItemOrder item;

  TempOrderAddEvent({required this.item});
}

class TempOrderUpdateEvent extends TempOrderEvent {
  final ItemOrder item;

  TempOrderUpdateEvent({required this.item});
}

class TempOrderDeleteEvent extends TempOrderEvent {
  final int id;
  TempOrderDeleteEvent({required this.id});
}

class TempOrderEmptyEvent extends TempOrderEvent {}
