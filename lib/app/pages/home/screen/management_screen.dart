import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/pages/insight/widget/container_with_shadow.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../../bloc/order/order_bloc.dart';
import '../../../model/order_model.dart';
import '../../../router/app_pages.dart';
import '../../../util/calculation_traffic.dart';
import '../../../util/util.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  late TextTheme _textTheme;

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ListView(
        physics: Platform.isIOS
            ? const ClampingScrollPhysics()
            : const RangeMaintainingScrollPhysics(),
        padding: const EdgeInsets.all(kDeffaultPadding),
        children: [
          _headerBox(),
          const SizedBox(
            height: kDeffaultPadding,
          ),
          const IRContainerShadow(
            child: Text(
              'Management',
            ),
          ),
          const SizedBox(
            height: kSmallPadding,
          ),
          IRContainerShadow(
            child: Column(
              children: [
                ListTile(
                  onTap: () => context.goNamed(Routes.stock),
                  leading: const Icon(
                    Icons.shopping_bag_outlined,
                  ),
                  title: const Text(
                    'Stock',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                  ),
                ),
                ListTile(
                  onTap: () => context.goNamed(Routes.category),
                  leading: const Icon(
                    TablerIcons.category,
                  ),
                  title: const Text(
                    'Category',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IRContainerShadow _headerBox() {
    final size = MediaQuery.sizeOf(context);
    // data
    final List<OrderModel> dataOrder =
        context.watch<OrderBloc>().state.orderModel ?? []; // get order data
    List<OrderModel> sortedData = trafficSortCalc48Hours(
      dataOrder: dataOrder,
    ); // calc data to get data today

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
              const Text('Order'),
              Text(
                '48 hours later',
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
}
