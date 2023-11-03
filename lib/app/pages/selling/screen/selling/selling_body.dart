import 'dart:math';

import 'package:kasir_app/app/bloc/draggable_item/draggable_item_cubit.dart';
import 'package:kasir_app/app/bloc/search/search_cubit.dart';
import 'package:kasir_app/app/bloc/temp_order/temp_order_bloc.dart';
import 'package:kasir_app/app/model/item_model.dart';
import 'package:kasir_app/app/model/order_model.dart';
import 'package:kasir_app/app/util/constant.dart';
import 'package:kasir_app/app/util/dialog_collection.dart';
import 'package:kasir_app/app/util/global_function.dart';
import 'package:kasir_app/app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/app/widget/tile_item.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../bloc/item/item_bloc.dart';
import '../../../../bloc/order/order_bloc.dart';

import '../../../../theme/app_theme.dart';
import '../../widget/chip_filter.dart';

class SellingScreenBody extends StatefulWidget {
  const SellingScreenBody({super.key});

  @override
  State<SellingScreenBody> createState() => _SellingScreenBodyState();
}

class _SellingScreenBodyState extends State<SellingScreenBody> {
  late TextEditingController qtyC;
  late TextEditingController noteC;
  late TextEditingController nameC;
  late GlobalKey<FormState> nameFormKey;
  late GlobalKey<FormState> noteFormKey;
  late int selectedIndex;
  late bool isOrder;
  late OrderBloc orderBloc;
  late String token;
  late double textScaleFactor;

  @override
  void initState() {
    qtyC = TextEditingController();
    nameC = TextEditingController();
    noteC = TextEditingController();
    nameFormKey = GlobalKey<FormState>();
    noteFormKey = GlobalKey<FormState>();
    selectedIndex = 0;
    isOrder = false;
    token = '';
    orderBloc = context.read<OrderBloc>();
    super.initState();
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

  void _orderOn({
    required int quantity,
    ItemOrder? item,
    ItemModel? itemModel,
    String? note,
  }) {
    assert(_debugOrderOn(item, itemModel));
    // var quantity = int.parse(qtyC.text);
    final priceItem = double.parse(itemModel!.sellingPrice!) * quantity;
    context.read<TempOrderBloc>().add(
          TempOrderAddEvent(
            item: item ??
                ItemOrder(
                  detail: note ?? '',
                  name: itemModel.name,
                  basicPrice: itemModel.basicPrice,
                  sellingPrice: priceItem.toString(),
                  quantity: quantity,
                ),
          ),
        );
  }

  void _orderUpdate({required OrderModel orderModel, required ItemOrder item}) {
    print(orderModel.toJson());
    // context.read<TempOrderBloc>().add(TempOrderUpdateEvent(item: item));
    int indexItem = orderModel.items!.indexWhere((element) => element.name == item.name);
    // print(item.detail);
    context.read<TempOrderBloc>().add(
          TempOrderUpdateEvent(orderModel: orderModel..items![indexItem] = item),
        );
  }

  void _itemOnTap(ItemModel item) {
    DialogCollection.dialogItem(
      context,
      item,
      onSubmit: (item, quantity, note) {
        final dataAll = context.read<TempOrderBloc>().state.orderModel; // ambil data dari bloc
        final checkData = dataAll?.items?.indexWhere(
          (element) => element.name == item.name,
        ); // cari data

        // edit stock item local
        final newItem = item.copyWith(
          originalStock: item.stock,
          stock: item.stock! - quantity,
        );
        context.read<ItemBloc>().add(ItemEditLocalEvent(itemModel: newItem));
        //
        if (checkData == null || checkData == -1) {
          //-1 adalah data yang sama tidak di temukan
          _orderOn(
            quantity: quantity,
            itemModel: item,
            note: note,
          );
        } else {
          // jika item ditemukan

          var dataItem = dataAll!.items![checkData]; // ambil data sesuai dari cari data
          var qty = dataItem.quantity! + quantity;
          var price = double.parse(dataItem.sellingPrice!) * qty;
          var detail = '';
          if (dataItem.detail!.isNotEmpty && note.isNotEmpty) {
            detail = '${dataItem.detail!}, $note';
          }
          dataItem.quantity = qty;
          dataItem.sellingPrice = price.toString();
          dataItem.detail = detail;
          _orderUpdate(item: dataItem, orderModel: dataAll);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    return RefreshIndicator(
      onRefresh: () async {
        GlobalFunction.refresh(context);
      },
      child: ListView(
        padding: const EdgeInsets.only(
          top: kSmallPadding,
          left: kDeffaultPadding,
          right: kDeffaultPadding,
        ),
        children: [
          const ListChipFilter(),
          _buildItemBloc(size),
        ],
      ),
    );
  }

  BlocBuilder _buildItemBloc(Size size) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, stateItem) {
        final itemModel = stateItem.itemModel;
        switch (stateItem.runtimeType) {
          case ItemLoadingState:
            return _buildShimmer();
          case ItemErrorState:
            return LayoutBuilder(builder: (context, constraint) {
              return ListView(
                children: [
                  SizedBox(
                    height: constraint.maxHeight,
                    child: const Center(
                      child: Text('Error'),
                    ),
                  )
                ],
              );
            });
          case ItemLoadedState:
            if (itemModel?.isEmpty ?? true) {
              return LayoutBuilder(builder: (context, constraint) {
                return ListView(
                  children: [
                    SizedBox(
                      height: constraint.maxHeight,
                      child: const Center(
                        child: Text(
                          'item does not exist yet',
                        ),
                      ),
                    ),
                  ],
                );
              });
            }
            context.read<SearchCubit>().fetchItem<List<ItemModel>>(itemModel);
            return _buildSearchBloc(size, stateItem);
          default:
            return const SizedBox();
        }
      },
    );
  }

  BlocBuilder _buildSearchBloc(Size size, ItemState stateItem) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, stateSearch) {
        switch (stateSearch.runtimeType) {
          case SearchEmpty:
            return const Center(
              child: Text(
                'Item not found',
              ),
            );
          case const (SearchComplete<List<ItemModel>>):
            stateSearch as SearchComplete<List<ItemModel>>;
            return _buildBody(size, stateSearch.result);
          default:
            return _buildBody(size, stateItem.itemModel!);
        }
      },
    );
  }

  Widget _buildBody(Size size, List<ItemModel> data) {
    return isTablet ? _buildTabletItem(size, data) : _buildMobileItem(size, data);
  }

  Widget _buildShimmer() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
      children: [
        const ListChipFilter(),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: kSmallPadding,
            ),
            shrinkWrap: true,
            itemCount: 7,
            itemBuilder: (context, index) => _itemShimmer(),
          ),
        ),
      ],
    );
  }

  ListTile _itemShimmer() {
    final size = MediaQuery.of(context).size;
    return ListTile(
      leading: SizedBox(
        height: size.height * 0.073,
        width: size.height * 0.073,
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(1000),
        // ),
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
        ),
      ),
      title: Container(
        // width: 70,
        height: size.height * .012,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      subtitle: Container(
        // width: 140,
        height: size.height * .012,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      trailing: Container(
        width: size.width * 0.1,
        height: size.height * .025,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  ListView _buildTabletItem(Size size, List<ItemModel> data) {
    return ListView.builder(
      shrinkWrap: true,
      // padding: const EdgeInsets.only(top: kSmallPadding),
      scrollDirection: Axis.vertical,
      physics: RangeMaintainingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        // final sizeImageItem = size.height * 0.5;
        // final sizeImageItemOnDrag = size.height * 0.1;
        ItemModel item = data[index];
        String leadingText = takeLetterIdentity(item.name!);
        // return LongPressDraggable<ItemModel>(
        //   onDragStarted: () => context.read<DraggableItemCubit>().dragOn(),
        //   onDragEnd: (details) => context.read<DraggableItemCubit>().dragOff(),
        //   data: item,
        //   feedback: SizedBox(
        //     height: sizeImageItemOnDrag,
        //     width: sizeImageItemOnDrag,
        //     child: CircleAvatar(
        //       backgroundColor: kCircleAvatarBackground,
        //       child: Image.asset(
        //         'assets/images/drink-${Random().nextInt(4) + 1}.png',
        //         fit: BoxFit.contain,
        //       ),
        //     ),
        //   ),
        //   child: TileItem(
        //     onTap: () {
        //       DialogCollection.dialogItem(
        //         context,
        //         item,
        //         onSubmit: (item, quantity, note) {
        //           // var dataAll = context.read<TempOrderBloc>().state.orderModel;
        //           // var checkData = dataAll?.items?.indexWhere(
        //           //   (element) => element.id == item.id,
        //           // );
        //           // // when item is added in order
        //           // if (checkData == null || checkData == -1) {
        //           //   //-1 adalah data yang sama tidak di temukan
        //           //   _orderOn(
        //           //     quantity: quantity,
        //           //     itemModel: item,
        //           //     note: note,
        //           //   );
        //           // } else {
        //           //   var dataItem = dataAll!.items![checkData];
        //           //   var qty = dataItem.quantity! + quantity;
        //           //   var price =
        //           //       double.parse(dataItem.sellingPrice!) + double.parse(item.sellingPrice!);
        //           //   var detail = '${dataItem.detail!}, $note';
        //           //   dataItem.quantity = qty;
        //           //   dataItem.sellingPrice = price.toString();
        //           //   dataItem.detail = detail;
        //           //   _orderUpdate(item: dataItem, orderModel: dataAll);
        //           // }
        //         },
        //       );
        //     },
        //     sizeImage: sizeImageItem,
        //     leadingText: leadingText,
        //     title: item.name!,
        //     subtitle: item.description!,
        //     trailing: currencyFormat(item.sellingPrice!),
        //     isLeadingImage: false,
        //   ),
        // );
        return TileItem(
          onTap: () => _itemOnTap(item),
          // onTap: () {
          //   DialogCollection.dialogItem(
          //     context,
          //     item,
          //     onSubmit: (item, quantity, note) {
          //       // var dataAll = context.read<TempOrderBloc>().state.orderModel;
          //       // var checkData = dataAll?.items?.indexWhere(
          //       //   (element) => element.id == item.id,
          //       // );
          //       // // when item is added in order
          //       // if (checkData == null || checkData == -1) {
          //       //   //-1 adalah data yang sama tidak di temukan
          //       //   _orderOn(
          //       //     quantity: quantity,
          //       //     itemModel: item,
          //       //     note: note,
          //       //   );
          //       // } else {
          //       //   var dataItem = dataAll!.items![checkData];
          //       //   var qty = dataItem.quantity! + quantity;
          //       //   var price =
          //       //       double.parse(dataItem.sellingPrice!) + double.parse(item.sellingPrice!);
          //       //   var detail = '${dataItem.detail!}, $note';
          //       //   dataItem.quantity = qty;
          //       //   dataItem.sellingPrice = price.toString();
          //       //   dataItem.detail = detail;
          //       //   _orderUpdate(item: dataItem, orderModel: dataAll);
          //       // }
          //     },
          //   );
          // },
          leadingText: leadingText,
          title: item.name!,
          subtitle: item.description!,
          trailing: currencyFormat(item.sellingPrice!),
          isLeadingImage: false,
        );
      },
    );
  }

  Widget _buildMobileItem(Size size, List<ItemModel> data) {
    data.sort(
      (a, b) => a.name!.compareTo(b.name!),
    );
    // return BlocBuilder<TempOrderBloc, TempOrderState>(
    //   builder: (context, state) {
    //     // if(state is TempOrderisOrderState){

    //     // }
    //     return ListView.builder(
    //       shrinkWrap: true,
    //       // padding: const EdgeInsets.only(top: 0),
    //       scrollDirection: Axis.vertical,
    //       physics: const ClampingScrollPhysics(),
    //       itemCount: data.length,
    //       itemBuilder: (context, index) {
    //         final sizeImageItem = size.height * 0.073;
    //         ItemModel item = data[index];
    //         // // check item stock equal to temporder
    //         // List<ItemOrder> itemOrder = context.read<TempOrderBloc>().state.orderModel?.items ?? [];
    //         // var indexCheckItem = itemOrder.indexWhere((element) => element.id == item.id);
    //         // if (indexCheckItem != -1) {
    //         //   item.stock = item.stock! - itemOrder[indexCheckItem].quantity!;
    //         // }

    //         String leadingText = takeLetterIdentity(item.name!);
    //         final bool enabled = item.stock != 0;

    //         return TileItem(
    //           onTap: () => _itemOnTap(item),
    //           enabled: enabled,
    //           sizeImage: sizeImageItem,
    //           leadingText: leadingText,
    //           title: item.name!,
    //           subtitle: item.description!,
    //           trailing: currencyFormat(item.sellingPrice!),
    //           isLeadingImage: false,
    //         );
    //       },
    //     );
    //   },
    // );
    return ListView.builder(
      shrinkWrap: true,
      // padding: const EdgeInsets.only(top: 0),
      scrollDirection: Axis.vertical,
      physics: const ClampingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final sizeImageItem = size.height * 0.073;
        ItemModel item = data[index];
        // // check item stock equal to temporder
        // List<ItemOrder> itemOrder = context.read<TempOrderBloc>().state.orderModel?.items ?? [];
        // var indexCheckItem = itemOrder.indexWhere((element) => element.id == item.id);
        // if (indexCheckItem != -1) {
        //   item.stock = item.stock! - itemOrder[indexCheckItem].quantity!;
        // }

        String leadingText = takeLetterIdentity(item.name!);
        final bool enabled = item.stock != 0;

        return TileItem(
          onTap: () => _itemOnTap(item),
          enabled: enabled,
          sizeImage: sizeImageItem,
          leadingText: leadingText,
          title: item.name!,
          subtitle: item.description!,
          trailing: currencyFormat(item.sellingPrice!),
          isLeadingImage: false,
        );
      },
    );
  }
}
