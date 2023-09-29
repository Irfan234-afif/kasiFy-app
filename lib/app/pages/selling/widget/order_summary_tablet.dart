import 'package:kasir_app/app/bloc/draggable_item/draggable_item_cubit.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:kasir_app/app/util/dialog_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/widget/tile_item_order.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../../bloc/order/order_bloc.dart';
import '../../../bloc/temp_order/temp_order_bloc.dart';
import '../../../model/item_model.dart';
import '../../../model/order_model.dart';
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
  late String token;

  @override
  void initState() {
    nameC = TextEditingController();
    noteC = TextEditingController();
    nameFormKey = GlobalKey<FormState>();

    orderBloc = context.read<OrderBloc>();
    token = '';
    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    noteC.dispose();
    super.dispose();
  }

  bool _debugOrderOn(ItemOrder? item, ItemModel? itemModel) {
    if (item != null && itemModel != null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('Parameter e siji wae blok.'),
        ErrorDescription('Asu raimu.'),
      ]);
    }
    return true;
  }

  void _orderAdd(OrderModel orderModel, String token) {
    orderBloc.add(
      OrderAddEvent(
        orderModel: orderModel,
        token: token,
      ),
    );
  }

  void _orderOn({
    required int quantity,
    ItemOrder? item,
    ItemModel? itemModel,
    String? note,
  }) {
    assert(_debugOrderOn(item, itemModel));
    // var quantity = int.parse(qtyC.text);
    context.read<TempOrderBloc>().add(
          TempOrderAddEvent(
            item: item ??
                ItemOrder(
                  detail: note ?? '',
                  name: itemModel!.name,
                  id: itemModel.id,
                  sellingPrice: itemModel.sellingPrice,
                  quantity: quantity,
                ),
          ),
        );
  }

  void _orderDelete(int id) {
    context.read<TempOrderBloc>().add(TempOrderDeleteEvent(id: id));
  }

  void _orderUpdate(ItemOrder item) {
    // context.read<TempOrderBloc>().add(TempOrderUpdateEvent(item: item));
    int indexItem = widget.orderModel.items!.indexWhere((element) => element.id == item.id);
    // print(item.detail);
    context.read<TempOrderBloc>().add(
          TempOrderUpdateEvent(orderModel: widget.orderModel..items![indexItem] = item),
        );
  }

  void _onAccept(ItemModel data) {
    OrderModel dataAll = widget.orderModel;
    DialogCollection.dialogItem(
      context,
      data,
      onSubmit: (item, quantity, note) {
        var checkData = dataAll.items?.indexWhere(
          (element) => element.id == item.id,
        );
        if (checkData == null || checkData == -1) {
          //-1 adalah data yang sama tidak di temukan
          _orderOn(
            quantity: quantity,
            itemModel: item,
            note: note,
          );
        } else {
          var dataItem = dataAll.items![checkData];
          var qty = dataItem.quantity! + quantity;
          var price = double.parse(dataItem.sellingPrice!) + double.parse(data.sellingPrice!);
          var detail = '${dataItem.detail!}, $note';
          dataItem.quantity = qty;
          dataItem.sellingPrice = price.toString();
          dataItem.detail = detail;
          // delete du
          _orderUpdate(dataItem);
          // _orderDelete(dataItem.id!);
          // _orderOn(
          //   quantity: quantity,
          //   item: dataItem,
          //   note: note,
          // );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final orderModel = widget.orderModel;
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: BlocBuilder<DraggableItemCubit, DraggableItemState>(
        builder: (context, state) {
          return DragTarget<ItemModel>(
            hitTestBehavior: HitTestBehavior.opaque,
            onAccept: _onAccept,
            builder: (context, dataAccepted, rejectedData) {
              if (state is DraggableItemOn) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: mediaQuery.padding.top, horizontal: kDeffaultPadding),
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.blue),
                    // ),
                    child: CustomPaint(
                      painter: DashedBorderPainter(
                        color: Colors.black26,
                        strokeWidth: 4,
                        dashWidth: 8,
                        dashSpace: 4,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              TablerIcons.download,
                              color: Colors.black26,
                              size: mediaQuery.size.height * .3,
                            ),
                            const Text(
                              "Tarik disini",
                              style: TextStyle(
                                color: Colors.black26,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Container(
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orderModel.items?.length,
                            itemBuilder: (context, index) {
                              final data = orderModel.items![index];
                              return Column(
                                children: [
                                  TileItemOrder(
                                    data: data,
                                    onTap: () {
                                      DialogCollection.bottomSheetEditItem(
                                        context,
                                        data,
                                        onSubmit: (item) {
                                          int indexItem = orderModel.items!
                                              .indexWhere((element) => element.id == item.id);
                                          // print(item.detail);
                                          context.read<TempOrderBloc>().add(
                                                TempOrderUpdateEvent(
                                                    orderModel: orderModel
                                                      ..items![indexItem] = item),
                                              );
                                        },
                                        onDelete: (id) {
                                          _orderDelete(id);
                                        },
                                      );
                                    },
                                  ),
                                  const Divider(),
                                ],
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
                            'Pesanan atas nama',
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
                                  return 'Isi nama';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Atas nama..',
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
                              text: 'Tambahkan catatan ',
                              children: [
                                TextSpan(
                                  text: '(opsional)',
                                  style: themeData.textTheme.bodyMedium!
                                      .copyWith(color: Colors.black45),
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
                                  bool flag = await DialogCollection.confirmDialog(context,
                                      titleText: 'Pesanan akan di proses?');
                                  if (flag) {
                                    // print(orderModel.toJsonPost());
                                    _orderAdd(orderModel, token);
                                  }
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
                              listener: (context, state) {
                                // Lanjutan dari _orderAdd
                                if (state is OrderLoadedState) {
                                  context.pop(); // back from bottomSheet
                                  context
                                      .read<TempOrderBloc>()
                                      .add(TempOrderEmptyEvent()); // clearing TempOder
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
                              },
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
                                      width: 8,
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
              );
            },
          );
        },
      ),
    );
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
