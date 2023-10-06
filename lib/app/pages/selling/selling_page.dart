import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/bloc/order/order_bloc.dart';
import 'package:kasir_app/app/bloc/sales/sales_bloc.dart';
import 'package:kasir_app/app/bloc/search/search_cubit.dart';
import 'package:kasir_app/app/model/item_model.dart';
import 'package:kasir_app/app/model/order_model.dart';
import 'package:kasir_app/app/pages/selling/screen/selling/selling_body.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:kasir_app/app/util/constant.dart';
import 'package:kasir_app/app/util/dialog_collection.dart';
import 'package:kasir_app/app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../bloc/temp_order/temp_order_bloc.dart';
import 'widget/order_summary_tablet.dart';

class SellingPage extends StatefulWidget {
  const SellingPage({super.key});

  @override
  State<SellingPage> createState() => _SellingPageState();
}

class _SellingPageState extends State<SellingPage> {
  late TextEditingController qtyC;
  late TextEditingController noteC;
  late TextEditingController nameC;
  late GlobalKey<FormState> nameFormKey;
  late bool isOrder;
  late OrderBloc orderBloc;
  late String email;

  @override
  void initState() {
    qtyC = TextEditingController();
    nameC = TextEditingController();
    noteC = TextEditingController();
    nameFormKey = GlobalKey<FormState>();
    isOrder = false;
    email = context.read<AuthRepository>().firebaseAuth.currentUser?.email ?? '';
    orderBloc = context.read<OrderBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeData = Theme.of(context);

    // print(context.read<AuthBloc>().state);
    final size = mediaQuery.size;
    return BlocBuilder<TempOrderBloc, TempOrderState>(
      builder: (context, state) {
        return isTablet
            ? _buildTabletLayout(size, mediaQuery, state.orderModel!)
            : _buildMobileLayout(size, mediaQuery, state, themeData);
      },
    );
  }

  Widget _buildTabletLayout(Size size, MediaQueryData mediaQuery, OrderModel orderlModel) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Scaffold(
            appBar: _buildAppBar(size),
            body: const SellingScreenBody(),
          ),
        ),
        const Material(child: VerticalDivider()),
        Expanded(
          flex: 3,
          child: OrderSummaryTablet(orderModel: orderlModel),
        ),
      ],
    );
  }

  Stack _buildMobileLayout(
      Size size, MediaQueryData mediaQuery, TempOrderState state, ThemeData themeData) {
    return Stack(
      children: [
        Positioned.fill(
          child: Scaffold(
            appBar: _buildAppBar(size),
            // appBar: CustomAppBar(size: size, mediaQuery: mediaQuery),
            // drawer: Drawer(),
            body: const SellingScreenBody(),
          ),
        ),
        if (state is TempOrderisOrderState) _widgetOnOrder(size, themeData, state.orderModel!),
      ],
    );
  }

  // Order On
  Positioned _widgetOnOrder(Size size, ThemeData themeData, OrderModel orderModel) {
    final totalItem = orderModel.items?.length;
    final totalPrice = currencyFormat(orderModel.totalPrice!);
    return Positioned(
      bottom: 5,
      child: SafeArea(
        child: BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            // lanjutan ontap button
            if (state is OrderLoadedState) {
              context.read<SalesBloc>().add(SalesGetEvent(email));
              context.goNamed(Routes.orderSucces, extra: state.orderModel!.first);
            }
          },
          child: GestureDetector(
            onTap: () {
              // _bottomSheetOrder(orderModel, themeData);
              DialogCollection.bottomSheetOrder(
                context,
                orderModel,
                onConfirm: (orderModel) async {
                  orderBloc.add(
                    OrderAddEvent(
                      orderModel: orderModel,
                      email: email,
                    ),
                  );
                  // final nexStep = await orderBloc.;
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: kDeffaultPadding),
              padding: const EdgeInsets.symmetric(vertical: 5),
              width: size.width - kDeffaultPadding * 2,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(kRadiusDeffault),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                        titleTextStyle: themeData.textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                        leadingAndTrailingTextStyle: themeData.textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                        leading: const Icon(
                          TablerIcons.shopping_bag,
                          size: 35,
                          color: Colors.white,
                        ),
                        title: Text(
                          '$totalItem Item',
                        ),
                        trailing: Text(
                          totalPrice,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      List<ItemModel> itemModel = context.read<ItemBloc>().state.itemModel!;
                      for (var itemOrder in orderModel.items!) {
                        var sameItem =
                            itemModel.singleWhere((element) => element.name == itemOrder.name);
                        var restoreStockItem = sameItem.copyWith(
                          stock: sameItem.originalStock,
                        );
                        context
                            .read<ItemBloc>()
                            .add(ItemEditLocalEvent(itemModel: restoreStockItem));
                      }
                      context.read<TempOrderBloc>().add(TempOrderEmptyEvent());
                    },
                    icon: const Icon(
                      TablerIcons.x,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(Size size) {
    return AppBar(
      toolbarHeight: kToolbarHeight + 10,
      centerTitle: true,
      // leadingWidth: 70,
      // leading: BackButton(),
      title: SearchBar(
        onChanged: (value) {
          context.read<SearchCubit>().performSearch<List<ItemModel>>(value);
        },
        hintText: 'Search..',
        trailing: [
          const Icon(
            Icons.search,
            color: Colors.black38,
          ),
          SizedBox(
            width: size.width * .02,
          ),
        ],
      ),
    );
  }
}
