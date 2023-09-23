import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/app/bloc/category/category_bloc.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/bloc/order/order_bloc.dart';
import 'package:kasir_app/app/bloc/sales/sales_bloc.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';

class GlobalFunction {
  static void refresh(BuildContext context) {
    String token = context.read<AuthRepository>().userModel.token ?? '';
    context.read<SalesBloc>().add(SalesGetEvent(token));
    context.read<ItemBloc>().add(ItemInitialEvent(token));
    context.read<OrderBloc>().add(OrderGetEvent(token: token));
    context.read<CategoryBloc>().add(CategoryGetEvent(token));
  }
}
