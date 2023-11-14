import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/bloc/order/order_bloc.dart';
import 'package:kasir_app/app/model/item_model.dart';
import 'package:kasir_app/app/pages/insight/widget/container_with_shadow.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/util/global_function.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../../bloc/sales/sales_bloc.dart';
import '../../../model/order_model.dart';
import '../../../model/sales_model.dart';
import '../../../model/user_model.dart';
import '../../../theme/app_theme.dart';
import '../../../util/calculation_traffic.dart';
import '../../../util/util.dart';
import '../../../widget/card_item_label.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserModel _userModel;

  late TextTheme _textTheme;

  @override
  void initState() {
    _userModel = context.read<AuthRepository>().userModel;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: RefreshIndicator(
        onRefresh: () async {
          GlobalFunction.refresh(context);
        },
        child: ListView(
          physics: Platform.isIOS
              ? const ClampingScrollPhysics()
              : const RangeMaintainingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: kDeffaultPadding,
            vertical: kDeffaultPadding,
          ),
          children: [
            BlocBuilder<SalesBloc, SalesState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case SalesLoadingState:
                    return _headerBoxShimmer(size);
                  case SalesLoadedState:
                    state as SalesLoadedState;
                    final salesModel = state.salesModel;

                    // widget body
                    return _headerBox(
                      salesData: salesModel,
                    );
                  case SalesErrorState:
                    state as SalesErrorState;
                    return Center(
                      child: Text(state.msg),
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            _notificationsBody(),
            // _sellingBody(textHeaderStyle),
            const SizedBox(
              height: kDeffaultPadding,
            ),
            _insightBody(),
            const SizedBox(
              height: kDeffaultPadding,
            ),
            _quickAccesBody(),
            // _insightBody(textHeaderStyle),
          ],
        ),
      ),
    );
  }

  Widget _notificationsBody() {
    // declarate data
    // List<OrderModel> dataOrder =
    //     context.watch<OrderBloc>().state.orderModel ?? [];
    // List<ItemModel> dataItem = context.watch<ItemBloc>().state.itemModel ?? [];

    // List<ItemModel> listItemStock = listItemLowStock(data: dataItem) ?? [];
    // List<ItemOrder> listItemRank = trafficItemRankCalc(dataSorted: dataOrder);
    //

    // late String itemNameLowStock;
    // if (listItemStock.first.stock != null && listItemStock.first.stock! <= 5) {
    //   itemNameLowStock = listItemStock.first.name!;
    // } else {
    //   itemNameLowStock = 'Stock is available';
    // }
    // print(itemNameLowStock);

    final defaultTextStyle =
        _textTheme.titleSmall!.copyWith(color: Colors.white);
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, itemState) {
        List<ItemModel> listItemStock = [];
        String lowStockText = 'Stock is available';
        if (itemState is ItemLoadedState) {
          listItemStock =
              listItemLowStock(data: itemState.itemModel) ?? []; // calc data
          if (listItemStock.isNotEmpty && listItemStock.first.stock! <= 5) {
            lowStockText = listItemStock.first.name!;
          }
        }
        return BlocBuilder<OrderBloc, OrderState>(
          builder: (context, orderState) {
            List<ItemOrder> listItemRank = [];
            if (orderState is OrderLoadedState) {
              listItemRank =
                  trafficItemRankCalc(dataSorted: orderState.orderModel ?? []);
            }

            return Column(
              children: [
                const IRContainerShadow(
                  child: Text(
                    'Notifications',
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: IRCardItemHome(
                        color: Colors.red,
                        icon: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            lowStockText,
                            style: defaultTextStyle.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        label: 'Low stock',
                        labelStyle: defaultTextStyle,
                        onTap: () {
                          context.goNamed(Routes.stock,
                              extra: lowStockText != 'Stock is available'
                                  ? lowStockText
                                  : null);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: IRCardItemHome(
                        color: Colors.lightBlue,
                        icon: Text(
                          listItemRank.isNotEmpty
                              ? listItemRank.first.name!
                              : 'Item not yet',
                          style: defaultTextStyle.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        label: 'Item terlaris',
                        labelStyle: defaultTextStyle,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: IRCardItemHome(
                        color: Colors.amber,
                        icon: Text(
                          'Bahan Kue',
                          style: defaultTextStyle.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        label: 'Category',
                        labelStyle: defaultTextStyle,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  IRContainerShadow _insightBody() {
    final size = MediaQuery.sizeOf(context);
    // data
    final List<OrderModel> dataOrder =
        context.watch<OrderBloc>().state.orderModel ?? []; // get order data
    List<OrderModel> sortedData = trafficOrderCalc(
        dataOrder: dataOrder,
        indexFilter: 2); // calc data to get traffic this month

    return IRContainerShadow(
      constraints: BoxConstraints(
        minWidth: double.maxFinite,
        minHeight: size.height * 0.2,
        maxHeight: size.height * 0.3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Insight'),
              Text(
                'This month',
                style: _textTheme.titleSmall!.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              tooltipBehavior: TooltipBehavior(enable: true),
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries<OrderModel, String>>[
                ColumnSeries<OrderModel, String>(
                  animationDuration: 800,
                  dataSource: sortedData,
                  name: 'Order',
                  xValueMapper: (data, index) => mmmdFormat(data.orderAt!),
                  yValueMapper: (data, index) {
                    // logic to know length per-column
                    int length = sortedData
                        .where((element) =>
                            mmmdFormat(element.orderAt!) ==
                            mmmdFormat(data.orderAt!))
                        .length;

                    return length;
                  },
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 4,
                    width: 4,
                    borderWidth: 3,
                    borderColor: Colors.blueGrey,
                  ),
                  // Enable data label
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAccesBody() {
    final textTheme = Theme.of(context).textTheme;
    return IRContainerShadow(
      child: DefaultTextStyle(
        style: textTheme.titleSmall!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _IRIconWithLabel(
              onTap: () => context.goNamed(Routes.addItem),
              icondata: TablerIcons.pencil_plus,
              label: "Add Stock",
            ),
            _IRIconWithLabel(
              onTap: () => context.goNamed(Routes.selling),
              icondata: TablerIcons.shopping_cart_plus,
              label: "Add Order",
            ),
            _IRIconWithLabel(
              onTap: () => context.goNamed(Routes.category),
              icondata: TablerIcons.circle_plus,
              label: "Add Category",
            ),
          ],
        ),
      ),
    );
  }

  Card _headerBox({
    List<SalesModel>? salesData,
  }) {
    // get the order and revenue today
    double revenue = 0;
    String parseRevenue = '0';
    int orderCount = 0;
    if (salesData?.isNotEmpty ?? false) {
      final dataToday = sortSalesToday(salesData ?? []);
      // di looping agar mendapatkan sales yang hari ini
      for (var element in dataToday) {
        revenue += double.parse(element.revenue!);
      }
      orderCount = dataToday.length;
      parseRevenue = currencyFormat(revenue.toString());
    }
    //

    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDeffaultPadding,
          vertical: kDeffaultPadding,
        ),
        // constraints: BoxConstraints.tight(Size.fromHeight(size.height * 0.15)),
        constraints: const BoxConstraints(
          minHeight: 150,
          maxHeight: 150,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kRadiusDeffault),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 0.5,
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _userModel.shopName ?? 'Shop name not found',
              style: _textTheme.titleLarge!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
              // textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Today',
              style: _textTheme.titleSmall!.copyWith(color: Colors.black54),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _IRTextHeaderLabel(
                      headerText: orderCount.toString(),
                      labelText: 'Order',
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: _IRTextHeaderLabel(
                      headerText: parseRevenue,
                      labelText: 'Revenue',
                    ),
                  ),
                  // Text(
                  //   'Order count today : $orderCount',
                  //   style: _textTheme.titleSmall!
                  //       .copyWith(color: Colors.white, fontSize: 12),
                  // ),
                  // Text(
                  //   'Revenue today : $parseRevenue',
                  //   style: _textTheme.titleSmall!
                  //       .copyWith(color: Colors.white, fontSize: 12),
                  // ),
                  // SizedBox(
                  //   width: 8,
                  // ),
                  // Expanded(
                  //   child: Container(
                  //     color: Colors.amber,
                  //   ),
                  // ),
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  Container _headerBoxShimmer(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDeffaultPadding,
        vertical: kDeffaultPadding,
      ),
      constraints: BoxConstraints.tight(Size.fromHeight(size.height * 0.15)),
      decoration: const BoxDecoration(
        color: kPrimaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kSmallRadius),
                child: Container(
                  width: 200,
                  height: 27,
                  color: Colors.white38,
                ),
              ),
            ),
          ),
          const Spacer(),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kSmallRadius),
              child: Container(
                width: 180,
                height: 16,
                color: Colors.white38,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kSmallRadius),
              child: Container(
                width: 150,
                height: 16,
                color: Colors.white38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IRIconWithLabel extends StatelessWidget {
  const _IRIconWithLabel(
      {this.onTap, required this.icondata, required this.label});

  final VoidCallback? onTap;
  final IconData icondata;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(kRadiusDeffault),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                icondata,
                color: Colors.green,
                size: 28,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IRTextHeaderLabel extends StatelessWidget {
  const _IRTextHeaderLabel({required this.headerText, required this.labelText});

  final String headerText, labelText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          headerText,
          style: textTheme.titleMedium!.copyWith(
            color: Colors.black,
            fontSize: 18,
            // fontWeight: FontWeight.w00,
          ),
        ),
        Text(
          labelText,
          style: textTheme.labelMedium!.copyWith(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
