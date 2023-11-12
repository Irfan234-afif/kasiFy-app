import 'package:kasir_app/app/repository/auth_repository.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:kasir_app/app/util/dialog_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/widget/tile_item_order.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../../bloc/item/item_bloc.dart';
import '../../../bloc/order/order_bloc.dart';
import '../../../bloc/sales/sales_bloc.dart';
import '../../../bloc/temp_order/temp_order_bloc.dart';
import '../../../model/item_model.dart';
import '../../../model/order_model.dart';
import '../../../model/sales_model.dart';
import '../../../util/util.dart';

class OrderSummaryTablet extends StatefulWidget {
  const OrderSummaryTablet({
    super.key,
    required this.orderModel,
  });

  final OrderModel orderModel;

  @override
  State<OrderSummaryTablet> createState() => _OrderSummaryTabletState();
}

class _OrderSummaryTabletState extends State<OrderSummaryTablet> {
  late TextEditingController nameC;
  late TextEditingController noteC;
  late GlobalKey<FormState> nameFormKey;

  late OrderBloc orderBloc;
  late String email;

  @override
  void initState() {
    nameC = TextEditingController();
    noteC = TextEditingController();
    nameFormKey = GlobalKey<FormState>();

    orderBloc = context.read<OrderBloc>();
    email = context.read<AuthRepository>().firebaseAuth.currentUser?.email ?? '';
    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    noteC.dispose();
    super.dispose();
  }

  void _listenerAfterOrder(BuildContext context, OrderState state) {
    // Lanjutan dari _orderAdd
    if (state is OrderLoadedState) {
      context.goNamed(Routes.orderSucces, extra: state.orderModel!.first);
      context.read<TempOrderBloc>().add(TempOrderEmptyEvent()); // clearing TempOder
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          content: Text(
            'Berhasil menambahkan order',
          ),
        ),
      );
      nameC.clear();
      noteC.clear();
    } else if (state is OrderErrorState) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('terjadi kesalahan'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Kembali'),
              ),
            ],
          );
        },
      );
    }
  }

  void _addToSales(OrderModel data) {
    double revenue = double.parse(data.totalPrice!);
    double profit = 0;

    // find profit
    // with loop item in orderModel
    for (ItemOrder item in data.items!) {
      // parse String to double
      double parseSellingPrice = double.parse(item.sellingPrice!);
      double parseBasicPrice = double.parse(item.basicPrice!);
      profit += parseSellingPrice - parseBasicPrice;
    }

    OrderSales orderSales = OrderSales(
      itemCount: data.items?.length,
      orderAt: data.orderAt,
      totalPrice: data.totalPrice,
    );
    SalesModel salesModel = SalesModel(
      createdAt: data.orderAt,
      order: orderSales,
      profit: profit.toString(),
      revenue: revenue.toString(),
    );

    context.read<SalesBloc>().add(
          SalesAddEvent(
            email: email,
            data: salesModel,
          ),
        );
  }

  void _updateStockItem(OrderModel data) {
    for (var element in data.items!) {
      ItemModel itemData = ItemModel(name: element.name, stock: element.quantity);
      context.read<ItemBloc>().add(ItemDecreaseStockEvent(email, itemModel: itemData));
    }
  }

  void _tileOnTap({required OrderModel orderModel, required ItemOrder dataItem}) {
    DialogCollection.bottomSheetEditItem(
      context,
      dataItem,
      onSubmit: (item) {
        // update stock item
        final itemBloc = context.read<ItemBloc>();
        // find data item in model
        final itemModel = itemBloc.state.itemModel;
        int indexWhere = itemModel!.indexWhere((element) => element.name == item.name);
        var sameItem = itemModel[indexWhere];
        // create new data item with new stock <- originalStock - quantity
        final newItem = sameItem.copyWith(
          stock: sameItem.originalStock! - item.quantity!,
        );
        itemBloc.add(ItemEditLocalEvent(
          itemModel: newItem,
        ));
        //

        // update TempOrder
        // ketika quantity 0 maka item akan di delete dari tempOrder
        if (item.quantity == 0) {
          context.read<TempOrderBloc>().add(TempOrderDeleteEvent(name: item.name!));
        } else {
          var whereItem = orderModel.items!.indexWhere((element) => element.name == item.name);
          context.read<TempOrderBloc>().add(
              // TempOrderUpdateEvent(item: item),
              TempOrderUpdateEvent(orderModel: orderModel..items![whereItem] = item));
        }
      },
      onDelete: (name) async {
        bool? flag = await DialogCollection.dialogConfirm(
          context: context,
          titleText: 'Confirm delete',
          contentText: "Item order will be delete",
        );
        if (flag!) {
          // ignore: use_build_context_synchronously
          context.pop();
          // ignore: use_build_context_synchronously
          context.read<TempOrderBloc>().add(TempOrderDeleteEvent(name: name));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocBuilder<TempOrderBloc, TempOrderState>(builder: (context, state) {
      final OrderModel orderModel = state.orderModel!;
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDeffaultPadding,
            vertical: kDeffaultPadding + 24,
          ),
          constraints: const BoxConstraints.expand(),
          alignment: Alignment.center,
          child: orderModel.items!.isNotEmpty
              ? ListView(
                  // padding: EdgeInsets.only(bottom: kDeffaultPadding),
                  children: [
                    Text(
                      "Order summary",
                      style: themeData.textTheme.titleLarge,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orderModel.items?.length ?? 0,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final data = orderModel.items![index];
                        return TileItemOrder(
                          data: data,
                          onTap: () => _tileOnTap(orderModel: orderModel, dataItem: data),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal",
                          style: themeData.textTheme.labelMedium!.copyWith(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          currencyFormat(orderModel.totalPrice ?? ''),
                          style: themeData.textTheme.labelMedium!.copyWith(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Order in the name of',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Form(
                      key: nameFormKey,
                      child: TextFormField(
                        controller: nameC,
                        style: themeData.textTheme.titleSmall,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Fill name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Name..',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kSmallRadius),
                            borderSide: const BorderSide(
                              color: Colors.black26,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kSmallRadius),
                            borderSide: const BorderSide(
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 8,
                    ),
                    RichText(
                      text: TextSpan(
                        style: themeData.textTheme.bodyMedium,
                        text: 'Add notes',
                        children: [
                          TextSpan(
                            text: '(optional)',
                            style: themeData.textTheme.bodyMedium!.copyWith(color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: noteC,
                      style: themeData.textTheme.titleSmall,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Note..',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kSmallRadius),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kSmallRadius),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kButtonColor3,
                        shape: RoundedRectangleBorder(
                          borderRadius: kSmallBorderRadius,
                        ),
                      ),
                      onPressed: () async {
                        if (nameFormKey.currentState!.validate()) {
                          if (orderBloc.state is! OrderLoadingState) {
                            orderModel.name = nameC.text;
                            orderBloc.add(
                              OrderAddEvent(
                                orderModel: orderModel,
                                email: email,
                              ),
                            );

                            _updateStockItem(orderModel);

                            _addToSales(orderModel);
                          }
                        }
                      },
                      child: BlocConsumer<OrderBloc, OrderState>(
                        listenWhen: (previous, current) {
                          if (previous is OrderAddingState && current is OrderLoadedState) {
                            return true;
                          }
                          return false;
                        },
                        listener: _listenerAfterOrder,
                        builder: (context, state) {
                          if (state is OrderLoadingState || state is OrderAddingState) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                TablerIcons.truck_delivery,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: kSmallPadding,
                              ),
                              Text(
                                'Order',
                                style: themeData.textTheme.labelLarge,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        if (orderBloc.state is! OrderLoadingState) {
                          for (var element in orderModel.items!) {
                            context.read<ItemBloc>().add(
                                  ItemRestockEvent(email, itemName: element.name!),
                                );
                          }
                          context.read<TempOrderBloc>().add(TempOrderEmptyEvent());
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            TablerIcons.eraser,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Delete all',
                            style: themeData.textTheme.labelLarge!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text('Tambah item dengan seret item atau klik item'),
                ),
        ),
      );
    });
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = 0;

    // Top border
    while (x < size.width) {
      double length = x + dashWidth;
      if (length > size.width) {
        length = size.width;
      }
      Path path = Path();
      path.moveTo(x, 0);
      path.lineTo(length, 0);
      canvas.drawPath(path, paint);
      x += dashWidth + dashSpace;
    }

    // Right border
    double y = 0;
    while (y < size.height) {
      double length = y + dashWidth;
      if (length > size.height) {
        length = size.height;
      }
      Path path = Path();
      path.moveTo(size.width, y);
      path.lineTo(size.width, length);
      canvas.drawPath(path, paint);
      y += dashWidth + dashSpace;
    }

    // Bottom border
    x = size.width;
    while (x > 0) {
      double length = x - dashWidth;
      if (length < 0) {
        length = 0;
      }
      Path path = Path();
      path.moveTo(x, size.height);
      path.lineTo(length, size.height);
      canvas.drawPath(path, paint);
      x -= dashWidth + dashSpace;
    }

    // Left border
    y = size.height;
    while (y > 0) {
      double length = y - dashWidth;
      if (length < 0) {
        length = 0;
      }
      Path path = Path();
      path.moveTo(0, y);
      path.lineTo(0, length);
      canvas.drawPath(path, paint);
      y -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
