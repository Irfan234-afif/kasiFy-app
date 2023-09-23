part of 'order_bloc.dart';

@immutable
abstract class OrderState {
  final List<OrderModel>? orderModel;

  const OrderState({this.orderModel});

  copyWith({
    List<OrderModel>? orderModel,
  }) {
    return (orderModel: orderModel ?? []);
  }
}

class OrderInitial extends OrderState {
  const OrderInitial({required super.orderModel});
}

class OrderLoadingState extends OrderState {}

class OrderAddingState extends OrderState {}

class OrderLoadedState extends OrderState {
  const OrderLoadedState({required super.orderModel});
}

class OrderEmptyState extends OrderState {
  const OrderEmptyState({required super.orderModel});
}

class OrderErrorState extends OrderState {
  final String msg;

  const OrderErrorState(this.msg);
}
