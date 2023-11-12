import 'dart:math';

import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';
import 'package:kasir_app/app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/widget/initial_image.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../bloc/order/order_bloc.dart';
import '../bloc/temp_order/temp_order_bloc.dart';
import '../model/item_model.dart';
import '../model/order_model.dart';
import '../theme/app_theme.dart';
import '../widget/tile_item_order.dart';
import 'constant.dart';

class DialogCollection {
  DialogCollection._();

  static void dialogItem(
    BuildContext context,
    final ItemModel item, {
    Function(ItemModel item, int quantity, String note)? onSubmit,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => _DialogItem(item: item, onSubmit: onSubmit),
    );
  }

  static void sheetDetailOrderDone(
      {required BuildContext context, required OrderModel orderModel}) {
    final mediaQuery = MediaQuery.of(context);
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height - kToolbarHeight,
      ),
      context: context,
      builder: (context) => _BottomSheetOrderDone(data: orderModel),
    );
  }

  static void bottomSheetEditItem(
    BuildContext context,
    ItemOrder item, {
    Function(ItemOrder item)? onSubmit,
    Function(String name)? onDelete,
  }) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      // constraints: BoxConstraints.tight(Size.fromHeight(size.height - kToolbarHeight)),
      builder: (context) {
        return _BottomSheetEditItem(
          data: item,
          onSubmit: onSubmit,
          onDelete: onDelete,
        );
      },
    );
  }

  static void bottomSheetOrder(
    BuildContext context,
    OrderModel data, {
    Function(OrderModel orderModel)? onConfirm,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final themeData = Theme.of(context);
    final TextEditingController nameC = TextEditingController();
    final TextEditingController noteC = TextEditingController();
    final GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();
    final OrderBloc orderBloc = context.read<OrderBloc>();
    // GetStorage box = GetStorage();
    // nameC.text = orderModel.name ?? '';
    nameC.text = context.read<TempOrderBloc>().state.orderModel?.name ?? '';
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      showDragHandle: true,
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height - kToolbarHeight,
      ),
      context: context,
      builder: (context) {
        return BlocBuilder<TempOrderBloc, TempOrderState>(
          builder: (context, state) {
            final orderModel = state.orderModel!;
            return Container(
              padding: const EdgeInsets.symmetric(
                vertical: kDeffaultPadding + 10,
                horizontal: kDeffaultPadding + 10,
              ),
              // height: mediaQuery.size.height * .7,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,

                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order summary",
                              style: themeData.textTheme.titleLarge,
                            ),
                            GestureDetector(
                              onTap: () {},
                              behavior: HitTestBehavior.translucent,
                              child: Text(
                                'Add items',
                                style: themeData.textTheme.titleMedium!.copyWith(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderModel.items?.length,
                          itemBuilder: (context, index) {
                            var data = orderModel.items![index];
                            return Column(
                              children: [
                                TileItemOrder(
                                  data: data,
                                  onTap: () {
                                    DialogCollection.bottomSheetEditItem(
                                      context,
                                      data,
                                      onSubmit: (item) {
                                        // update stock item
                                        final itemBloc = context.read<ItemBloc>();
                                        final itemModel = itemBloc.state.itemModel;
                                        int indexWhere = itemModel!
                                            .indexWhere((element) => element.name == item.name);
                                        var sameItem = itemModel[indexWhere];
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
                                          if (orderModel.items!.length == 1) {
                                            // ketika item nya hanya 1 dan quantity nya update ke 0
                                            // otomatis tidak ada item lagi maka context pop akan menutup bottom sheet
                                            // karna tempOrder sudah tidak ada atau sudah empty

                                            context.pop();
                                          }
                                          context
                                              .read<TempOrderBloc>()
                                              .add(TempOrderDeleteEvent(name: item.name!));
                                        } else {
                                          var whereItem = orderModel.items!
                                              .indexWhere((element) => element.name == item.name);
                                          context.read<TempOrderBloc>().add(
                                              // TempOrderUpdateEvent(item: item),
                                              TempOrderUpdateEvent(
                                                  orderModel: orderModel
                                                    ..items![whereItem] = item));
                                        }
                                      },
                                      onDelete: (name) {
                                        _itemDelete(context, name);
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
                        SizedBox(
                          height: mediaQuery.size.height * .02,
                        ),
                        const Text(
                          'Pesanan atas nama',
                        ),
                        Form(
                          key: nameFormKey,
                          child: TextFormField(
                            controller: nameC,
                            autofocus: true,
                            style: themeData.textTheme.titleSmall,
                            onChanged: (value) {
                              // box.write('textOrder', value);
                              context.read<TempOrderBloc>().add(TempOrderUpdateEvent(
                                  orderModel: orderModel.copyWith(name: value)));
                              // print(orderm)
                            },
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
                        const Divider(),
                        const Text(
                          'Tambahkan catatan',
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
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: themeData.elevatedButtonTheme.style!.copyWith(
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: kDeffaultPadding),
                      ),
                      backgroundColor: const MaterialStatePropertyAll(Colors.green),
                      minimumSize: const MaterialStatePropertyAll(
                        Size(double.infinity, 0),
                      ),
                    ),
                    onPressed: () async {
                      if (nameFormKey.currentState!.validate()) {
                        if (orderBloc.state is! OrderLoadingState) {
                          orderModel.name = nameC.text;
                          bool flag = await confirmOrder(context);
                          if (flag) {
                            // print(orderModel.toJsonPost());
                            // box.remove('textOrder');
                            onConfirm?.call(orderModel);
                          }
                        }
                      }
                    },
                    child: BlocConsumer<OrderBloc, OrderState>(
                      listener: (context, state) {
                        // Lanjutan dari onTap elevated button
                        if (state is OrderLoadedState) {
                          // context.pop(); // back from bottomSheet
                          nameC.clear();
                          noteC.clear();
                          // context
                          //     .read<TempOrderBloc>()
                          //     .add(TempOrderEmptyEvent()); // clearing TempOder
                        } else if (state is OrderErrorState) {
                          _errorDialog(context);
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
                    height: kSmallPadding,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      if (orderBloc.state is! OrderLoadingState) {
                        String email = context.read<AuthRepository>().userModel.email!;
                        // restoreStock Item
                        List<ItemModel> itemModel = context.read<ItemBloc>().state.itemModel!;
                        orderModel.items!.forEach((itemOrder) {
                          var sameItem =
                              itemModel.singleWhere((element) => element.name == itemOrder.name);
                          var restoreStockItem = sameItem.copyWith(
                            stock: sameItem.originalStock,
                          );
                          context
                              .read<ItemBloc>()
                              .add(ItemEditLocalEvent(itemModel: restoreStockItem));
                        });

                        // kembalikan stock item
                        orderModel.items!.forEach((element) {
                          context.read<ItemBloc>().add(
                                ItemRestockEvent(email, itemName: element.name!),
                              );
                        });
                        context.pop();
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
                  const SizedBox(
                    height: kSmallPadding,
                  ),
                  OutlinedButton(
                    style: themeData.outlinedButtonTheme.style,
                    onPressed: () {
                      if (orderBloc.state is! OrderLoadingState) {
                        context.pop();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(
                          width: kSmallPadding,
                        ),
                        Text(
                          'Kembali',
                          style: themeData.textTheme.labelLarge!.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static void snakBarSuccesAddItem(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Row(
          children: [
            Icon(
              TablerIcons.check,
              color: Colors.white,
            ),
            Text('Succes add item'),
          ],
        ),
      ),
    );
  }

  static void _itemDelete(BuildContext context, String name) async {
    bool? flag = await DialogCollection.dialogConfirm(
      context: context,
      titleText: 'Confirm delete',
      contentText: "Item order will be delete",
    );
    if (flag!) {
      // ignore: use_build_context_synchronously
      context.pop();
      // ignore: use_build_context_synchronously
      final tempOrderBloc = context.read<TempOrderBloc>();
      tempOrderBloc.add(TempOrderDeleteEvent(name: name));
      // TODO : cross check when delete item length 1
      // if (tempOrderBloc.state.orderModel!.items!.isEmpty) {
      // ignore: use_build_context_synchronously
      // context.pop();
      // }
    }
  }

  static Future<dynamic> _errorDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Terjadi kesalahan'),
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

  static Future<bool> confirmOrder(BuildContext context) async {
    final textTheme = Theme.of(context).textTheme;
    final elevatedButtonTheme = Theme.of(context).elevatedButtonTheme;
    return await showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            context.pop(false);
            return Future.value(true);
          },
          child: AlertDialog.adaptive(
            title: const Text(
              'Confirm',
            ),
            content: const Text(
              'Order will be processed?',
            ),
            actions: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    vertical: kSmallPadding,
                    horizontal: kDeffaultPadding,
                  ),
                ),
                onPressed: () {
                  context.pop(false);
                },
                child: const Text(
                  'Cancel',
                ),
              ),
              ElevatedButton(
                style: elevatedButtonTheme.style!.copyWith(
                  minimumSize: const MaterialStatePropertyAll(Size(70, 0)),
                  backgroundColor: const MaterialStatePropertyAll(Colors.green),
                  padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(
                      vertical: kSmallPadding,
                      horizontal: kDeffaultPadding,
                    ),
                  ),
                ),
                onPressed: () {
                  context.pop(true);
                },
                child: Text(
                  'Yes',
                  style: textTheme.titleSmall!.copyWith(
                    color: kTextColor2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> confirmLogout(BuildContext context) async {
    final textTheme = Theme.of(context).textTheme;
    return await showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text('Confirm'),
        content: const Text(
          'Log out account?',
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(
                vertical: kSmallPadding,
                horizontal: kDeffaultPadding,
              ),
            ),
            onPressed: () => context.pop(false),
            child: const Text(
              'Cancel',
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(70, 0),
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(
                vertical: kSmallPadding,
                horizontal: kDeffaultPadding,
              ),
            ),
            onPressed: () {
              context.pop(true);
            },
            child: Text(
              'Yes',
              style: textTheme.titleSmall!.copyWith(
                color: kTextColor2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool?> dialogConfirm({
    required BuildContext context,
    required String titleText,
    required String contentText,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(titleText),
        content: Text(
          contentText,
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(
                vertical: kSmallPadding,
                horizontal: kDeffaultPadding,
              ),
            ),
            onPressed: () => context.pop(false),
            child: Text(
              'Cancel',
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(
                vertical: kSmallPadding,
                horizontal: kDeffaultPadding,
              ),
            ),
            onPressed: () => context.pop(true),
            child: Text(
              "Yes",
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogItem extends StatefulWidget {
  final ItemModel item;
  final Function(ItemModel item, int quantity, String note)? onSubmit;
  const _DialogItem({required this.item, this.onSubmit});

  @override
  State<_DialogItem> createState() => __DialogItemState();
}

class __DialogItemState extends State<_DialogItem> {
  late TextEditingController qtyC;
  late TextEditingController noteC;
  late GlobalKey<FormState> noteFormKey;

  late int stock;

  @override
  void initState() {
    qtyC = TextEditingController(
      text: '1',
    );
    noteC = TextEditingController();
    noteFormKey = GlobalKey<FormState>();
    stock = widget.item.stock! - 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    final item = widget.item;

    int quantity = int.parse(qtyC.text);
    double totalPrice = double.parse(widget.item.sellingPrice!) * quantity;

    final String identityName = takeLetterIdentity(widget.item.name!);
    return AlertDialog(
      // padd
      scrollable: true,
      title: const Text(
        'Order',
      ),

      content: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 134,
            width: 134,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(134),
              // backgroundColor: kCircleAvatarBackground,
              child: InitialImage(
                text: identityName,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(
            height: size.height * .015,
          ),
          Text(
            item.name!,
            style: textTheme.titleLarge,
          ),
          SizedBox(
            height: size.height * .01,
          ),
          Text(
            item.description!,
            style: textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const Divider(),

          // Jumlah pesanan
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Increment Decrement qty
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (qtyC.text != '1') {
                          var currentQty = int.parse(qtyC.text);
                          qtyC.text = (currentQty - 1).toString();
                          stock += 1;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(kSmallPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kSmallRadius),
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: const Icon(
                        TablerIcons.minus,
                        size: 28,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: (size.width * .15).clamp(50, 70),
                    child: TextField(
                      controller: qtyC,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium,
                      enabled: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (stock != 0) {
                        setState(() {
                          stock -= 1;
                          var currentQty = int.parse(qtyC.text);
                          qtyC.text = (currentQty + 1).toString();
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(kSmallPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kSmallRadius),
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: const Icon(
                        TablerIcons.plus,
                        size: 28,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // widget on stock empty
          if (stock == 0)
            Text(
              'Stock is empty',
              style: TextStyle(color: Colors.red),
            ),
          Text(
            'Total amoount : ${currencyFormat(totalPrice.toString())}',
          ),
          Text(
            'Stock : $stock',
          ),
          SizedBox(
            height: 8,
          ),
          // Wrap(
          //   spacing: 6,
          //   alignment: WrapAlignment.center,
          //   children: List.generate(
          //     dataChip.length,
          //     (index) {
          //       return ChoiceChip(
          //         selectedColor: Colors.green,
          //         label: Text(dataChip[index]),
          //         selected: selectedChip == index,
          //         onSelected: (value) {
          //           if (selectedChip == index) {
          //             setState(() {
          //               selectedChip = null;
          //               noteC.clear();
          //             });
          //           } else {
          //             setState(() {
          //               noteC.text = dataChip[index];
          //               selectedChip = index;
          //             });
          //           }
          //         },
          //       );
          //     },
          //   ),
          // ),
          SizedBox(
            height: 8,
          ),
          // Textfield request
          Form(
            key: noteFormKey,
            child: TextFormField(
              controller: noteC,
              style: textTheme.titleSmall,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Note..',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: kDeffaultPadding,
                ),
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
          const Divider(
            height: 30,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kButtonColor3,
            ),
            onPressed: () {
              if (noteFormKey.currentState!.validate()) {
                context.pop();
                final ItemModel newData = item
                  ..copyWith(
                    stock: stock,
                    sellingPrice: totalPrice.toString(),
                  );
                // save stock item in getStorage to keep watch when order is cancel
                // GetStorage().write(key, value)
                widget.onSubmit?.call(newData, int.parse(qtyC.text), noteC.text);
              }
            },
            child: Text(
              'Order',
              style: textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          OutlinedButton(
            // style: OutlinedButton.styleFrom(

            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(kSmallRadius),
            //   ),
            // ),
            onPressed: () {
              context.pop(false);
            },
            child: Text(
              'Batal',
              style: textTheme.titleMedium!.copyWith(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      // actionsAlignment: MainAxisAlignment.center,
      // actionsOverflowAlignment: OverflowBarAlignment.center,
    );
  }
}

class _BottomSheetOrderDone extends StatefulWidget {
  final OrderModel data;
  const _BottomSheetOrderDone({super.key, required this.data});

  @override
  State<_BottomSheetOrderDone> createState() => __BottomSheetOrderDoneState();
}

class __BottomSheetOrderDoneState extends State<_BottomSheetOrderDone> {
  @override
  Widget build(BuildContext context) {
    final orderModel = widget.data;
    final themeData = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    var nama = orderModel.name;
    var jumlahItem = orderModel.items!.length.toString();
    var orderAt = hoursFormat(orderModel.orderAt!);
    var totalPrice = currencyFormat(orderModel.totalPrice!);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: kSmallPadding,
        horizontal: kDeffaultPadding,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Detail order",
                  style: themeData.textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: mediaQuery.size.height * .02,
                ),
                _buildTextRow(
                  context: context,
                  title: 'Status ',
                  trailling: 'Selesai',
                ),
                _buildTextRow(
                  context: context,
                  title: 'Atas nama',
                  trailling: nama!,
                ),
                _buildTextRow(
                  context: context,
                  title: 'Jumlah item',
                  trailling: jumlahItem,
                ),
                _buildTextRow(
                  context: context,
                  title: 'Pesan pada jam',
                  trailling: orderAt,
                ),
                _buildTextRow(
                  context: context,
                  title: 'Subtotal',
                  trailling: totalPrice,
                  colorTrailing: Colors.green,
                ),
                SizedBox(
                  height: mediaQuery.size.height * .02,
                ),
                Text(
                  "Detail item",
                  style: themeData.textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderModel.items?.length,
                  itemBuilder: (context, index) {
                    var data = orderModel.items![index];
                    double priceItemTotal = double.parse(data.sellingPrice!) * data.quantity!;
                    var newPriceItem = currencyFormat(priceItemTotal.toString());
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leadingAndTrailingTextStyle: themeData.textTheme.titleMedium!.copyWith(
                            color: Colors.green,
                            fontSize: 16,
                          ),
                          titleTextStyle: themeData.textTheme.titleMedium!.copyWith(
                            color: Colors.black87,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(kSmallPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(kSmallRadius),
                              border: Border.all(
                                color: Colors.black12,
                              ),
                            ),
                            child: Text(
                              '${data.quantity}x',
                              style: themeData.textTheme.titleMedium!.copyWith(
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          title: Text(
                            data.name ?? '',
                          ),
                          subtitle: Text(
                            data.detail ?? '',
                          ),
                          trailing: Text(
                            newPriceItem,
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(mediaQuery.size.width, 0),
              padding: const EdgeInsets.symmetric(vertical: kDeffaultPadding),
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              // dial(orderModel.id!);
            },
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoadingState) {
                  return const CircularProgressIndicator(
                    color: Colors.white,
                  );
                }
                return Text(
                  'Pengembalian',
                  style: themeData.textTheme.labelLarge!,
                );
              },
            ),
          ),
          SizedBox(
            height: mediaQuery.size.height * .01,
          ),
          OutlinedButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              "Kembali",
              style: themeData.textTheme.labelLarge!.copyWith(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildTextRow(
      {required BuildContext context,
      required String title,
      required String trailling,
      Color? colorTrailing}) {
    final themeData = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$title : ",
            ),
            Text(
              trailling,
              style: themeData.textTheme.titleMedium!.copyWith(
                color: colorTrailing ?? Colors.black,
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class _BottomSheetEditItem extends StatefulWidget {
  // data
  final ItemOrder data;
  // onSubmit function return when submit ->
  // return new data ItemOrder
  final void Function(ItemOrder item)? onSubmit;
  // onDelete function return when delete
  // -> delete return name item for find item in model
  final void Function(String name)? onDelete;
  //
  const _BottomSheetEditItem({super.key, required this.data, this.onSubmit, this.onDelete});

  @override
  State<_BottomSheetEditItem> createState() => __BottomSheetEditItemState();
}

class __BottomSheetEditItemState extends State<_BottomSheetEditItem> {
  late TextEditingController qtyC, noteC;
  late GlobalKey<FormState> noteFormKey;

  late ItemBloc itemBloc;
  late ItemModel itemDatainModel;

  late int stock;

  late double originalPrice;
  late double totalPrice;

  @override
  void initState() {
    final item = widget.data;

    itemBloc = context.read<ItemBloc>();
    itemDatainModel = itemBloc.state.itemModel!.singleWhere((element) => element.name == item.name);

    qtyC = TextEditingController();
    noteC = TextEditingController();
    noteFormKey = GlobalKey<FormState>();

    qtyC.text = item.quantity.toString();
    noteC.text = item.detail ?? '';

    originalPrice = double.parse(item.sellingPrice!) / item.quantity!;
    totalPrice = double.parse(item.sellingPrice!);
    stock = itemDatainModel.stock!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.data;
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final textTheme = Theme.of(context).textTheme;
    final paddingHorizontal = isTablet ? kDeffaultPadding * 4 : kDeffaultPadding;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: paddingHorizontal,
        right: paddingHorizontal,
        bottom: mediaQuery.viewInsets.bottom + kDeffaultPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order',
            style: textTheme.titleLarge,
          ),
          const SizedBox(
            height: 18,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 134,
                width: 134,
                child: CircleAvatar(
                  backgroundColor: kCircleAvatarBackground,
                  child: Image.asset(
                    'assets/images/drink-${Random().nextInt(4) + 1}.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * .015,
              ),
              Text(
                item.name!,
                style: textTheme.titleLarge,
              ),
              SizedBox(
                height: size.height * .01,
              ),
              Text(
                item.detail!,
                style: textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const Divider(),
              // Jumlah pesanan
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Increment Decrement qty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (qtyC.text != '0') {
                            setState(() {
                              stock += 1;
                              var currentQty = int.parse(qtyC.text);
                              qtyC.text = (currentQty - 1).toString();
                              totalPrice = originalPrice * int.parse(qtyC.text);
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(kSmallPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kSmallRadius),
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: const Icon(
                            TablerIcons.minus,
                            size: 28,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: (size.width * .15).clamp(50, 70),
                        child: TextField(
                          controller: qtyC,
                          enabled: false,
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (stock != 0) {
                            setState(() {
                              stock -= 1;
                              var currentQty = int.parse(qtyC.text);
                              qtyC.text = (currentQty + 1).toString();
                              totalPrice = originalPrice * int.parse(qtyC.text);
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(kSmallPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kSmallRadius),
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: const Icon(
                            TablerIcons.plus,
                            size: 28,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (stock == 0)
                Text(
                  'Stock is empty',
                  style: TextStyle(color: Colors.red),
                ),
              Text(
                'Total harga : ${(currencyFormat(totalPrice.toString()))}',
              ),
              Text(
                'Stock : $stock',
              ),
              const SizedBox(
                height: 8,
              ),

              // Wrap(
              //   spacing: 6,
              //   direction: Axis.horizontal,
              //   children: List.generate(
              //     dataChip.length,
              //     (index) {
              //       return ChoiceChip(
              //         selectedColor: Colors.green,
              //         label: Text(dataChip[index]),
              //         selected: selectedChip == index,
              //         onSelected: (value) {
              //           if (selectedChip == index) {
              //             setState(() {
              //               selectedChip = null;
              //             });
              //           } else {
              //             setState(() {
              //               noteC.text = dataChip[index];
              //               selectedChip = index;
              //             });
              //           }
              //         },
              //       );
              //     },
              //   ),
              // ),
              const SizedBox(
                height: 8,
              ),
              // Textfield request
              Form(
                key: noteFormKey,
                child: TextFormField(
                  controller: noteC,
                  style: textTheme.titleSmall,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Isi note atau pilih pilihan varian';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Note..',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: kDeffaultPadding,
                    ),
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
              const Divider(
                height: 30,
              ),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kButtonColor3,
                  shape: RoundedRectangleBorder(
                    borderRadius: kSmallBorderRadius,
                  ),
                ),
                onPressed: () {
                  if (stock != itemDatainModel.stock) {
                    // jika stock berubah maka akan di update lagi
                    final newItem = itemDatainModel.copyWith(
                      stock: stock,
                    );
                    context.read<ItemBloc>().add(ItemEditLocalEvent(itemModel: newItem));
                  }
                  // if (noteFormKey.currentState!.validate()) {
                  context.pop();
                  // OrderModel(
                  //   items: [],
                  // );
                  item.sellingPrice = totalPrice.toString();
                  item.detail = noteC.text;
                  item.quantity = int.parse(qtyC.text);
                  // item.description = noteC.text;
                  // _orderOn(item);
                  widget.onSubmit?.call(item);
                  // }
                },
                child: Text(
                  'Save',
                  style: textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: kSmallBorderRadius,
                  ),
                ),
                onPressed: () {
                  widget.onDelete?.call(item.name!);
                },
                child: Text(
                  'Delete',
                  style: textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              OutlinedButton(
                onPressed: () {
                  context.pop(false);
                },
                child: Text(
                  'Batal',
                  style: textTheme.titleMedium!.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
