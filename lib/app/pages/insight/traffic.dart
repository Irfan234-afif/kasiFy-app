import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/app/bloc/sales/sales_bloc.dart';
import 'package:kasir_app/app/model/order_model.dart';
import 'package:kasir_app/app/model/sales_model.dart';
import 'package:kasir_app/app/pages/insight/widget/button_filter.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:kasir_app/app/util/util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../bloc/order/order_bloc.dart';
import '../../util/calculation_traffic.dart';

class TrafficPage extends StatefulWidget {
  const TrafficPage({super.key});

  @override
  State<TrafficPage> createState() => _TrafficPageState();
}

class _TrafficPageState extends State<TrafficPage> {
  late int indexFilter;
  late bool enableMarker;

  @override
  void initState() {
    indexFilter = 1;
    enableMarker = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Traffic',
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, stateOrder) {
          List<OrderModel> orderModel = stateOrder.orderModel ?? [];
          switch (stateOrder.runtimeType) {
            case OrderLoadingState:
              return LayoutBuilder(
                builder: (context, constraint) => ListView(
                  children: [
                    SizedBox(
                      height: constraint.maxHeight,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              );
            case OrderLoadedState:
              return BlocBuilder<SalesBloc, SalesState>(
                builder: (context, stateSales) {
                  List<SalesModel> salesModel = stateSales.salesModel ?? [];
                  switch (stateSales.runtimeType) {
                    case SalesLoadingState:
                      return LayoutBuilder(
                        builder: (context, constraint) => ListView(
                          children: [
                            SizedBox(
                              height: constraint.maxHeight,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                        ),
                      );
                    case SalesLoadedState:
                      salesModel.sort(
                        (a, b) => a.createdAt!.compareTo(b.createdAt!),
                      );
                      orderModel.sort(
                        (a, b) => a.orderAt!.compareTo(b.orderAt!),
                      );
                      return _buildBody(
                        indexFilter,
                        orderModel,
                      );

                    default:
                      return const SizedBox();
                  }
                },
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  void _changeIndexFilter(int newIndex) {
    if (newIndex != indexFilter) {
      setState(() {
        indexFilter = newIndex;
      });
    }
  }

  void _changeMarker(bool? value) {
    if (enableMarker != value) {
      setState(() {
        enableMarker = value!;
      });
    }
  }

  Widget _buildBody(int indexFilter, List<OrderModel> orderModel) {
    // if (salesModel.isEmpty) {
    //   return const Center(
    //     child: Text(
    //       'No data cant show',
    //     ),
    //   );
    // }
    final textTheme = Theme.of(context).textTheme;
    // declarate newData sort

    late String Function(DateTime) metode;

    // sorting data by filter
    /// 0 => Year
    /// 1 => Month
    /// 2 => Day
    ///
    switch (indexFilter) {
      case 0:
        metode = DateFormat.y().format;
        break;
      case 1:
        metode = DateFormat.LLL().format;
        break;
      case 2:
        metode = DateFormat.MMMd().format;
        break;
      case 3:
        metode = hoursFormat;
        break;
      default:
    }
    List<OrderModel> sortedData = trafficOrderCalc(dataOrder: orderModel, indexFilter: indexFilter);
    List<ItemOrder> newDataItemOrder = trafficItemRankCalc(dataSorted: sortedData);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: kDeffaultPadding),
      children: [
        ButtonFilter(
          index: indexFilter,
          onTap: _changeIndexFilter,
        ),
        const SizedBox(
          height: kSmallPadding,
        ),
        CheckboxListTile(
          value: enableMarker,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('Marker'),
          onChanged: _changeMarker,
          dense: true,
        ),
        const SizedBox(
          height: kSmallPadding,
        ),
        // _ChartRevenue(
        //   title: 'Revenue & Profit',
        //   isMarker: enableMarker,
        //   data: newDataSales,
        //   metode: metode,
        // ),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          title: ChartTitle(
            text: 'Order',
            textStyle: textTheme.titleMedium,
          ),
          // Enable tooltip
          tooltipBehavior: TooltipBehavior(enable: true),
          // tap
          series: <ChartSeries<OrderModel, String>>[
            LineSeries<OrderModel, String>(
              dataSource: sortedData,
              name: 'Order',
              xValueMapper: (OrderModel order, _) => metode(order.orderAt!),
              yValueMapper: (OrderModel order, index) {
                // logic to know length per-column
                int length = orderModel
                    .where((element) => metode(element.orderAt!) == metode(order.orderAt!))
                    .length;
                return length;
              },
              markerSettings: MarkerSettings(
                  isVisible: enableMarker,
                  height: 4,
                  width: 4,
                  borderWidth: 3,
                  borderColor: Colors.blueGrey),
              // Enable data label
              dataLabelSettings: const DataLabelSettings(
                isVisible: false,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: kDeffaultPadding,
        ),
        SfCircularChart(
          title: ChartTitle(),
          series: [
            PieSeries<ItemOrder, String>(
              dataSource: newDataItemOrder,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                // color: Colors.white,
                // textStyle: TextStyle(color: Colors.white),
                builder: (data, point, series, pointIndex, seriesIndex) => Text(
                  '${data.name}\n${data.quantity}',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              // dataLabelMapper: (datum, index) => datum.name,
              xValueMapper: (data, index) => data.name,
              yValueMapper: (data, index) => data.quantity,
            ),
          ],
        ),
        const SizedBox(
          height: kDeffaultPadding,
        ),
        Text(
          'Table Item',
          style: textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: kDeffaultPadding,
        ),
        _listItemRank(newDataItemOrder),
      ],
    );
  }

  Column _listItemRank(List<ItemOrder> newDataItemOrder) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Name Item',
                style: textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                'Quantity',
                style: textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        // SizedBox(
        //   height: kDeffaultPadding,
        // ),
        const Divider(
          color: Colors.black,
          height: 24,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newDataItemOrder.length,
          separatorBuilder: (context, index) => const Divider(
            height: 24,
          ),
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    newDataItemOrder[index].name!,
                    style: textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    newDataItemOrder[index].quantity.toString(),
                    style: textTheme.titleSmall!.copyWith(
                      color: kPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
