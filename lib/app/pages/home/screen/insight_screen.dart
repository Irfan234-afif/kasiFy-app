import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/app/pages/insight/widget/container_with_shadow.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:kasir_app/app/util/util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../bloc/sales/sales_bloc.dart';
import '../../../model/sales_model.dart';
import '../../../router/app_pages.dart';
import '../../../util/calculation_traffic.dart';
import '../../../widget/card_item_label.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ListView(
        physics:
            Platform.isIOS ? const ClampingScrollPhysics() : const RangeMaintainingScrollPhysics(),
        padding: const EdgeInsets.all(kDeffaultPadding),
        children: [
          _headerBox(textTheme),
          const SizedBox(
            height: kDeffaultPadding,
          ),
          _insightBody(context),
        ],
      ),
    );
  }

  Column _insightBody(BuildContext context) {
    return Column(
      children: [
        const IRContainerShadow(
          child: Text('Insight'),
        ),
        const SizedBox(
          height: kSmallPadding,
        ),
        Row(
          children: [
            Expanded(
              child: IRCardItemHome(
                height: 150,
                onTap: () => context.goNamed(Routes.traffic),
                label: "Traffic Order",
                icon: Expanded(
                  child: SizedBox(
                    width: 70,
                    child: Image.asset('assets/icons/traffic_icon.png'),
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
                onTap: () => context.goNamed(Routes.economy),
                label: "Traffic Economy",
                icon: Expanded(
                  child: SizedBox(
                    width: 70,
                    child: Image.asset('assets/icons/economy_icon.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  IRContainerShadow _headerBox(TextTheme textTheme) {
    return IRContainerShadow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon(
          //   TablerIcons.timeline,
          //   size: 45,
          // ),
          Text(
            'Economy',
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '48 Hours later',
              style: textTheme.titleSmall!.copyWith(
                fontSize: 12,
              ),
            ),
          ),
          BlocBuilder<SalesBloc, SalesState>(
            builder: (context, salesState) {
              final List<SalesModel> sortedData =
                  sortEconomy48Hours(data: salesState.salesModel ?? []);

              return _ChartRevenue(data: sortedData, metode: hoursFormat);
            },
          )
        ],
      ),
    );
  }
}

class _ChartRevenue extends StatefulWidget {
  const _ChartRevenue({required this.data, required this.metode, this.title, this.isMarker = true});

  final List<SalesModel> data;
  final String Function(DateTime data) metode;
  final String? title;
  final bool isMarker;

  @override
  State<_ChartRevenue> createState() => _ChartRevenueState();
}

class _ChartRevenueState extends State<_ChartRevenue> {
  late ZoomPanBehavior _zoomPanBehavior;
  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.MMMd(),
        intervalType: DateTimeIntervalType.days,
      ),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      title: widget.title != null
          ? ChartTitle(
              text: widget.title!,
              textStyle: textTheme.titleMedium,
            )
          : null,
      // Enable tooltip
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries<SalesModel, DateTime>>[
        ColumnSeries<SalesModel, DateTime>(
          animationDuration: 800,
          dataSource: widget.data,
          name: 'Revenue',
          xValueMapper: (SalesModel sales, _) => sales.createdAt!,
          yValueMapper: (SalesModel sales, _) => double.parse(sales.revenue!),
          markerSettings: MarkerSettings(
              isVisible: widget.isMarker,
              height: 4,
              width: 4,
              borderWidth: 3,
              borderColor: Colors.blueGrey),
          // Enable data label
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
        ),
        ColumnSeries<SalesModel, DateTime>(
          animationDuration: 800,
          dataSource: widget.data,
          color: Colors.amber,
          name: 'Profit',
          xValueMapper: (SalesModel sales, _) => sales.createdAt!,
          yValueMapper: (SalesModel sales, _) => double.parse(sales.profit!),
          markerSettings: MarkerSettings(
              isVisible: widget.isMarker,
              height: 4,
              width: 4,
              // shape: DataMarkerType.Circle,
              borderWidth: 3,
              borderColor: Colors.blueGrey),
          // Enable data label
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
        ),
      ],
    );
  }
}
