import 'package:kasir_app/app/bloc/search/search_cubit.dart';
import 'package:kasir_app/app/model/order_model.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kasir_app/app/util/dialog_collection.dart';

import '../../../../bloc/order/order_bloc.dart';
import '../../../../util/constant.dart';
import '../../../../util/util.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late OrderBloc orderBloc;
  late SearchCubit searchCubit;
  late String token;

  @override
  void initState() {
    searchCubit = BlocProvider.of<SearchCubit>(context);
    orderBloc = context.read<OrderBloc>();
    token = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "History Orders",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: kSmallPadding,
          horizontal: kDeffaultPadding,
        ),
        children: [
          _headerSearch(),
          BlocProvider.value(
            value: searchCubit,
            child: _buildOrderBloc(),
          ),
        ],
      ),
    );
  }

  Column _headerSearch() {
    return Column(
      children: [
        SearchBar(
          onChanged: (value) =>
              searchCubit.performSearch<List<OrderModel>>(value),
          hintText: "Search order",
        ),
        const SizedBox(
          height: kDeffaultPadding,
        ),
      ],
    );
  }

  BlocBuilder<OrderBloc, OrderState> _buildOrderBloc() {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, stateOrder) {
        List<OrderModel>? orderData = List.from(stateOrder.orderModel ?? []);
        switch (stateOrder.runtimeType) {
          case OrderLoadingState:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case OrderErrorState:
            return const Center(
              child: Text('Error'),
            );
          case OrderLoadedState:
            // ketika data kosong akan mengembalikan teks sajja
            if (orderData.isEmpty) {
              return const Center(
                child: Text('no orders yet'),
              );
            }
            //

            // sorting berdasarkan done at nya
            orderData.sort(
              (a, b) => b.orderAt!.compareTo(a.orderAt!),
            );
            //

            // send orderData to searchCubit
            searchCubit.fetchItem<List<OrderModel>>(orderData);

            return BlocBuilder<SearchCubit, SearchState>(
              builder: (context, stateSearch) {
                switch (stateSearch.runtimeType) {
                  case SearchEmpty:
                    return const Center(
                      child: Text('Item not found'),
                    );
                  case const (SearchComplete<List<OrderModel>>):
                    stateSearch as SearchComplete<List<OrderModel>>;
                    return _buildListCard(stateSearch.result);
                  default:
                    return _buildListCard(orderData);
                }
              },
            );

          default:
            return const SizedBox();
        }
      },
    );
  }

  ListView _buildListCard(List<OrderModel> orderData) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orderData.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 8,
      ),
      itemBuilder: (context, index) {
        OrderModel data = orderData[index];

        // logic untuk check apakah orderan hari ini atau tidak
        late String orderAt;
        if (isToday(data.orderAt!)) {
          orderAt = hoursFormat(data.orderAt!);
        } else {
          orderAt = ymdHFormat(data.orderAt!);
        }
        // jika hari ini maka akan return jam, jika tidak maka return tanggal dan jam

        return _cardDoneItem(
          onTap: () {
            DialogCollection.sheetDetailOrderDone(
              context: context,
              orderModel: data,
            );
          },
          name: data.name!,
          subtitle: '${data.items?.length}',
          totalPrice: currencyFormat(data.totalPrice!),
          doneAt: orderAt,
        );
      },
    );
  }

  GestureDetector _cardDoneItem({
    required String name,
    required String subtitle,
    required String totalPrice,
    required String doneAt,
    Function()? onDone,
    Function()? onTap,
    // required int amount
  }) {
    final themeData = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        surfaceTintColor: Colors.green,
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(
              left: kSmallPadding, right: kSmallPadding, bottom: 8),
          child: Column(
            children: [
              ListTile(
                textColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Atas nama : $name',
                ),
                subtitle: Text(
                  'Jumlah item : $subtitle',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                trailing: Text(
                  totalPrice,
                ),
              ),
              const Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: RichText(
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                        text: 'Selesai pada : ',
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                        children: [
                          TextSpan(
                            text: doneAt,
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 0),
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                          vertical: isTablet
                              ? kDeffaultPadding + 8
                              : kDeffaultPadding,
                          horizontal: kDeffaultPadding),
                    ),
                    onPressed: onDone ?? () {},
                    child: Text(
                      'Pengembalian',
                      style: themeData.textTheme.labelMedium!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
