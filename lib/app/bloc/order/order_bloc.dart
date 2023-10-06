// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:kasir_app/app/model/order_model.dart';
import 'package:kasir_app/app/repository/order_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository = OrderRepository();
  OrderBloc() : super(const OrderInitial(orderModel: [])) {
    on<OrderGetTodayEvent>((event, emit) async {
      emit(OrderLoadingState());
      try {
        var res = await _orderRepository.getOrderToday(event.email);
        print(res);
        // var orderModel = orderModelFromList(res.data['data'] ?? []);
        // orderModel.sort(
        //   (a, b) => b.orderAt!.compareTo(a.orderAt!),
        // );
        // emit(
        //   OrderLoadedState(orderModel: orderModel),
        // );
      } on DioException catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(OrderErrorState(e.toString()));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });
    on<OrderGetEvent>((event, emit) async {
      emit(OrderLoadingState());
      try {
        var res = await _orderRepository.getOrder(event.email);
        print(res);
        // var orderModel = orderModelFromList(res.data['data'] ?? []);
        // orderModel.sort(
        //   (a, b) => b.orderAt!.compareTo(a.orderAt!),
        // );
        // emit(
        //   OrderLoadedState(orderModel: orderModel),
        // );
      } on DioException catch (e) {
        print(e.response);
        emit(OrderErrorState(e.toString()));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });
    on<OrderAddEvent>((event, emit) async {
      List<OrderModel> data = List.from(state.orderModel ?? []);
      try {
        emit(OrderAddingState());
        print(event.orderModel.items![0].sellingPrice);
        var res = await _orderRepository.addOrder(
          event.email,
          event.orderModel,
        );
        // var resData = OrderModel.fromJson(res.data['data'] ?? {});
        if (res != null) {
          data.add(res);
          data.sort(
            (a, b) => b.orderAt!.compareTo(a.orderAt!),
          );
        }
        emit(
          OrderLoadedState(orderModel: data),
        );
      } on DioException catch (e) {
        print(e);
        emit(OrderErrorState(e.toString()));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });
    on<OrderEmptyEvent>((event, emit) {
      emit(const OrderEmptyState(orderModel: []));
    });
  }
}
