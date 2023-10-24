import 'package:bloc/bloc.dart';
import 'package:kasir_app/app/model/order_model.dart';
import 'package:meta/meta.dart';

part 'temp_order_event.dart';
part 'temp_order_state.dart';

class TempOrderBloc extends Bloc<TempOrderEvent, TempOrderState> {
  TempOrderBloc() : super(TempOrderInitial(orderModel: OrderModel(items: []))) {
    on<TempOrderAddEvent>((event, emit) {
      var allData = state.orderModel;
      allData!.items!.add(event.item);
      allData.orderAt ??= DateTime.now();
      double totalPrice = 0;
      // forLoop untuk mendapat kan total price
      for (var element in allData.items!) {
        totalPrice += double.parse(element.sellingPrice!);
      }
      allData.totalPrice = totalPrice.toString();

      emit(
        TempOrderisOrderState(orderModel: allData),
      );
    });
    on<TempOrderUpdateEvent>((event, emit) {
      OrderModel orderModel = state.orderModel!;
      // var index = orderModel.items!.indexWhere((element) => element.id == event.item.id);
      // var itemFind = orderModel.items!.singleWhere((element) => element.id == event.item.id);
      // orderModel.items![index].copyWith(
      //   detail: event.item.detail,
      //   basicPrice: event.item.basicPrice,
      //   sellingPrice: event.item.sellingPrice,
      //   quantity: event.item.quantity,
      // );
      double totalPrice = 0;
      for (var element in event.orderModel.items!) {
        totalPrice += double.parse(element.sellingPrice!);
      }
      final newData = orderModel.copyWith(
        items: event.orderModel.items,
        name: event.orderModel.name,
        orderAt: event.orderModel.orderAt,
        totalPrice: totalPrice.toString(),
      );

      // print(orderModel.name);

      emit(TempOrderisOrderState(orderModel: newData));
    });
    on<TempOrderEmptyEvent>((event, emit) {
      // TODO : balikkan stock ketika temporder telah di batalkan
      try {
        emit(
          TempOrderEmptyState(
              orderModel: OrderModel(
            items: [],
          )),
        );
      } catch (e) {
        //
      }
    });
    on<TempOrderDeleteEvent>((event, emit) {
      OrderModel orderModel = state.orderModel!;
      var name = event.name;
      orderModel.items!.removeWhere((element) => element.name == name);
      if (orderModel.items!.isEmpty) {
        print('tempempty');
        emit(TempOrderEmptyState(orderModel: OrderModel(items: [])));
      } else {
        print('temp order');
        emit(TempOrderisOrderState(orderModel: orderModel));
      }
    });
  }
}
