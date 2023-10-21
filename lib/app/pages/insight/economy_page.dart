import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/app/pages/insight/widget/button_filter.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../bloc/sales/sales_bloc.dart';
import '../../model/sales_model.dart';
import '../../util/util.dart';

class EconomyPage extends StatefulWidget {
  const EconomyPage({super.key});

  @override
  State<EconomyPage> createState() => _EconomyPageState();
}

class _EconomyPageState extends State<EconomyPage> {
  late int indexFilter;
  late bool enableMarker;

  @override
  void initState() {
    indexFilter = 1;
    enableMarker = true;
    super.initState();
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

  void _showDialogChart({
    required List<SalesModel> data,
    required String Function(DateTime) metode,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: kDeffaultPadding, vertical: kDeffaultPadding * 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDeffaultPadding, vertical: kDeffaultPadding),
            child: _ChartRevenue(
              data: data,
              metode: metode,
              title: "Revenue & Profit",
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Economy'),
      ),
      body: BlocBuilder<SalesBloc, SalesState>(
        builder: (context, state) {
          List<SalesModel> salesModel = state.salesModel ?? [];
          switch (state.runtimeType) {
            case SalesLoadingState:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case SalesErrorState:
              return const Center(
                child: Text('Error'),
              );
            case SalesLoadedState:
              if (salesModel.isEmpty) {
                return const Center(
                  child: Text('No data can show'),
                );
              }
              salesModel.sort(
                (a, b) => a.createdAt!.compareTo(b.createdAt!),
              );
              // print(salesModel.length);

              List<SalesModel> sortedData = [];
              List<SalesModel> dataChart = [];
              late String Function(DateTime) metode;

              // sorting data by filter
              /// 0 => Year
              /// 1 => Month
              /// 2 => Day
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

              /// Sorting data
              for (var element in salesModel) {
                final dateNow = DateTime.now();
                switch (indexFilter) {
                  case 0:
                    sortedData.add(element);
                    break;
                  case 1:
                    if (element.createdAt!.year == dateNow.year) {
                      sortedData.add(element);
                    }
                    break;
                  case 2:
                    if (element.createdAt!.year == dateNow.year &&
                        element.createdAt!.month == dateNow.month) {
                      sortedData.add(element);
                    }
                    break;
                  case 3:
                    if (element.createdAt!.year == dateNow.year &&
                        element.createdAt!.month == dateNow.month &&
                        element.createdAt!.day == dateNow.day) {
                      sortedData.add(element);
                    }
                    break;
                  default:
                }
              }

              /// Sort table data
              for (var element in sortedData) {
                final parse = metode(element.createdAt!);

                int indexCheck = dataChart.indexWhere((newRank) {
                  return metode(newRank.createdAt!) == parse;
                });
                if (indexCheck == -1) {
                  dataChart.add(element);
                } else {
                  SalesModel sameData = dataChart[indexCheck];
                  final parseProfit = double.parse(sameData.profit!) +
                      double.parse(element.profit!);

                  final parseRevenue = double.parse(sameData.revenue!) +
                      double.parse(element.revenue!);
                  var copyData = sameData.copyWith(
                    revenue: parseRevenue.toString(),
                    profit: parseProfit.toString(),
                  );
                  dataChart.removeAt(indexCheck);
                  dataChart.insert(indexCheck, copyData);
                }
              }

              // if dataChart sort with a -> b
              dataChart.sort(
                (a, b) => a.createdAt!.compareTo(b.createdAt!),
              );
              // if data for table sort with b -> a
              final newDataSort = List<SalesModel>.from(dataChart);
              newDataSort.sort(
                (a, b) => b.createdAt!.compareTo(a.createdAt!),
              );

              return ListView(
                padding: const EdgeInsets.all(kDeffaultPadding),
                children: [
                  ButtonFilter(
                    index: indexFilter,
                    onTap: _changeIndexFilter,
                  ),
                  CheckboxListTile(
                    value: enableMarker,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Marker'),
                    onChanged: _changeMarker,
                    dense: true,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'Revenue & Profit',
                        style: textTheme.titleMedium!.copyWith(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () =>
                              _showDialogChart(data: dataChart, metode: metode),
                          icon: Icon(
                            TablerIcons.arrows_maximize,
                            size: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _ChartRevenue(
                    data: dataChart,
                    isMarker: enableMarker,
                    metode: metode,
                  ),
                  _tableRevenue(textTheme, newDataSort, metode),
                  _tableProfit(textTheme, newDataSort, metode)
                ],
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  Column _tableProfit(TextTheme textTheme, List<SalesModel> newDataRank,
      String Function(DateTime data) metode) {
    return Column(
      children: [
        Text(
          "Table Provit",
          style: textTheme.titleMedium!.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: kSmallPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Time',
                style: textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                'Provit',
                style: textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.black,
          height: 24,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newDataRank.length,
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
                    metode(newDataRank[index].createdAt!),
                    style: textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    currencyFormat(newDataRank[index].profit.toString()),
                    style: textTheme.titleSmall!.copyWith(
                      color: kPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // SizedBox(
                //   width: 4,
                // ),
                // Expanded(
                //   child: Text(
                //     currencyFormat(newDataRank[index].profit.toString()),
                //     style: textTheme.titleSmall!.copyWith(
                //       color: kPrimaryColor,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
              ],
            );
          },
        ),
      ],
    );
  }

  Column _tableRevenue(TextTheme textTheme, List<SalesModel> newDataRank,
      String Function(DateTime data) metode) {
    return Column(
      children: [
        Text(
          "Table Revenue",
          style: textTheme.titleMedium!.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: kSmallPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Time',
                style: textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                'Revenue',
                style: textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.black,
          height: 24,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newDataRank.length,
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
                    metode(newDataRank[index].createdAt!),
                    style: textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    currencyFormat(newDataRank[index].revenue.toString()),
                    style: textTheme.titleSmall!.copyWith(
                      color: kPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // SizedBox(
                //   width: 4,
                // ),
                // Expanded(
                //   child: Text(
                //     currencyFormat(newDataRank[index].profit.toString()),
                //     style: textTheme.titleSmall!.copyWith(
                //       color: kPrimaryColor,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ChartRevenue extends StatefulWidget {
  const _ChartRevenue(
      {required this.data,
      required this.metode,
      this.title,
      this.isMarker = true});

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
      primaryXAxis: CategoryAxis(),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      title: widget.title != null
          ? ChartTitle(
              text: widget.title!,
              textStyle: textTheme.titleMedium,
            )
          : null,
      // Enable tooltip
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries<SalesModel, String>>[
        LineSeries<SalesModel, String>(
          dataSource: widget.data,
          name: 'Revenue',
          xValueMapper: (SalesModel sales, _) =>
              widget.metode(sales.createdAt!),
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
        LineSeries<SalesModel, String>(
          dataSource: widget.data,
          color: Colors.amber,
          name: 'Profit',
          xValueMapper: (SalesModel sales, _) =>
              widget.metode(sales.createdAt!),
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
