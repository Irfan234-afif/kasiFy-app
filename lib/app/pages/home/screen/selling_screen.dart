import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kasir_app/app/bloc/order/order_bloc.dart';
import 'package:kasir_app/app/pages/insight/widget/container_with_shadow.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:kasir_app/app/widget/card_item_label.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../model/order_model.dart';
import '../../../util/calculation_traffic.dart';

class SellingScreen extends StatefulWidget {
  const SellingScreen({super.key});

  @override
  State<SellingScreen> createState() => _SellingScreenState();
}

class _SellingScreenState extends State<SellingScreen> {
  @override
  Widget build(BuildContext context) {
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
          _sellingBody(),
        ],
      ),
    );
  }

  Column _sellingBody() {
    return Column(
      children: [
        const IRContainerShadow(
          child: Text(
            'Selling',
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: IRCardItemHome(
                height: 150,
                onTap: () => context.goNamed(Routes.selling),
                label: "Selling",
                icon: Expanded(
                  child: SizedBox(
                    width: 70,
                    child: Image.asset('assets/icons/sell_icon.png'),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: IRCardItemHome(
                height: 150,
                onTap: () => context.goNamed(Routes.history),
                label: "History Page",
                icon: Expanded(
                  child: SizedBox(
                    width: 70,
                    child: Image.asset('assets/icons/history_icon.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  IRContainerShadow _headerBox() {
    // declarate data
    List<OrderModel> dataOrder =
        context.watch<OrderBloc>().state.orderModel ?? [];
    List<ItemOrder> newDataItemOrder =
        trafficItemRankCalc(dataSorted: dataOrder);
    //
    return IRContainerShadow(
      constraints: const BoxConstraints(
        minHeight: 200,
        maxHeight: 250,
      ),
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        title: ChartTitle(text: "Item terlaris"),
        legend: const Legend(
          isVisible: true,
        ),
        series: [
          PieSeries<ItemOrder, String>(
            animationDuration: 800,
            dataSource: newDataItemOrder,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              // color: Colors.white,
              // textStyle: TextStyle(color: Colors.white),
              builder: (data, point, series, pointIndex, seriesIndex) => Text(
                '${data.name}\n${data.quantity}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            // dataLabelMapper: (datum, index) => datum.name,
            xValueMapper: (data, index) => data.name,
            yValueMapper: (data, index) => data.quantity,
            legendIconType: LegendIconType.horizontalLine,
          ),
        ],
      ),
    );
  }
}
