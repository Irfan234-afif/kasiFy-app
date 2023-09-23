part of 'temp_order_bloc.dart';

@immutable
abstract class TempOrderState {
  final OrderModel? orderModel;

  const TempOrderState({this.orderModel});
}

class TempOrderInitial extends TempOrderState {
  const TempOrderInitial({super.orderModel});
}

class TempOrderisOrderState extends TempOrderState {
  const TempOrderisOrderState({required super.orderModel});
}

class TempOrderEmptyState extends TempOrderState {
  const TempOrderEmptyState({required super.orderModel});
}
